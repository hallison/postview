# Copyright (c) 2009 Hallison Batista
class Postview::Application::Build < Sinatra::Base #:nodoc: all

  register Sinatra::Mapping

  configure do
    set :root, Postview::ROOT
    set :public, root.join("lib/postview/application/shared/public")
    set :views, root.join("lib/postview/application/shared/views")

    enable :static

    map :root
    map :build
  end

  helpers do
    attr_reader :page, :settings, :build_path, :errors

    def site_settings_valid?
      site_domain_errors
      site_email_errors
      site_author_erros
      site_password_errors
      errors.values.compact.empty?
    end

  end

  before do
    settings_initialize
    build_path_initialize
    page_initialize
    errors_initialize
  end

  # Show all information for site.
  get root_path do
    page.title = "Settings"
    erb :setup
  end

  post build_path do
    page.title = "Build "
    if site_settings_valid?
      build!
      page.title += "successfuly"
      erb :build
    else
      page.title += "failure"
      erb :setup
    end
  end

private

  REGEX_DOMAIN = /((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6}$/
  REGEX_EMAIL  = /^(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@#{REGEX_DOMAIN}/

  def settings_initialize
    @settings = Postview::Settings.new(settings_params)
    @settings.site[:token] = Postview::Site.tokenize(@settings.site[:author], params[:password], @settings.site[:domain])
  end

  def settings_params
    { :site        => params[:site],
      :sections    => params[:sections],
      :directories => params[:directories] }
  end

  def page_initialize
    @page ||= OpenStruct.new(:name => "Build", :title => "", :keywords => "")
  end

  # All fields required
  def errors_initialize
    @errors = [ :domain, :author, :email, :password ].inject({}) do |hash, attribute|
      hash[:attribute] = nil
      hash
    end
  end

  def build_path_initialize
    @build_path = params[:build_path] || Postview.path
  end

  def site_domain_errors
    return unless params[:site]
    errors[:domain] = "Domain is required" if params[:site][:domain].to_s.empty?
    errors[:domain] = "Domain must be an address" unless params[:site][:domain].match(REGEX_DOMAIN)
  end

  def site_email_errors
    return unless params[:site]
    errors[:email] = "Email is required" if params[:site][:email].to_s.empty?
    errors[:email] = "Email must be an address" unless params[:site][:email].to_s.match(REGEX_EMAIL)
  end

  def site_author_erros
    return unless params[:site]
    errors[:author] = "Author name is required" if params[:site][:author].to_s.empty?
  end

  def site_password_errors
    errors[:password] = "Password is required" if params[:password].to_s.empty?
  end

  def settings_yaml
    @settings.to_hash.to_yaml.gsub(/^--- /,'')
  end

  def build!
    ARGV.clear
    require 'ruby-debug'
    debugger
    ARGV << "#{build_path}" << "--yaml" << settings_yaml
    Postview::CLI.run :create, ARGV
  end

end # class Postview::Application::Build

