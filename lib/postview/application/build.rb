# Copyright (c) 2009 Hallison Batista
class Postview::Application::Build < Sinatra::Base #:nodoc: all

  register Sinatra::Mapping

  configure do
    set :root, Postview::ROOT
    set :public, root.join("lib/postview/application/share")
    set :views, root.join("lib/postview/application/views")

    enable :static

    map :root
    map :build
  end

  helpers do
    attr_reader :page, :settings, :postview_path, :errors, :builded

    def site_settings_valid?
      site_domain_errors
      site_email_errors
      site_author_erros
      site_password_errors
      no_errors?
    end

    def no_errors?
      ATTRIBUTES_REQUIRED.map do |invalid|
        errors.send(invalid)
      end.compact.empty?
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
    page.title = "Build blog settings"
    erb :build
  end

  post build_path do
    if site_settings_valid?
      build!
      page.title = "Build successfully"
    end
    erb :build
  end

private

  ATTRIBUTES_REQUIRED =  [ :postview_path, :site_domain, :site_author, :site_email, :password ]
  REGEX_DOMAIN = /((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6}$/
  REGEX_EMAIL  = /^(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@#{REGEX_DOMAIN}/

  def settings_initialize
    @builded = false
    @settings = Postview::Settings.new(settings_params)
    @settings.site[:token] = Postview::Site.tokenize(@settings.site[:author], params[:password], @settings.site[:domain])
  end

  def settings_params
    { :site        => params[:site],
      :sections    => params[:sections],
      :directories => params[:directories] }
  end

  def page_initialize
    @page ||= OpenStruct.new(:title => "", :keywords => "")
  end

  # Fields required
  def errors_initialize
    @errors = Struct.new(*ATTRIBUTES_REQUIRED).new
  end

  def build_path_initialize
    @postview_path = params[:postview_path] || Postview.path
  end

  def site_domain_errors
    return unless params[:site]
    errors.site_domain = "Domain is required" if params[:site][:domain].to_s.empty?
    errors.site_domain = "Domain must be an address" unless params[:site][:domain].match(REGEX_DOMAIN)
  end

  def site_email_errors
    return unless params[:site]
    errors.site_email = "Email is required" if params[:site][:email].to_s.empty?
    errors.site_email = "Email must be an address" unless params[:site][:email].to_s.match(REGEX_EMAIL)
  end

  def site_author_erros
    return unless params[:site]
    errors.site_author = "Author name is required" if params[:site][:author].to_s.empty?
  end

  def site_password_errors
    errors.password = "Password is required" if params[:password].to_s.empty?
  end

  def settings_yaml
    @settings.to_hash.to_yaml.gsub(/^--- /,'')
  end

  def build!
    begin
      ARGV.clear
      ARGV << "#{postview_path}" << "--yaml" << settings_yaml
      Postview::CLI.run :create, ARGV
      @builded = true
    rescue RuntimeError => error
      page.title = "Build failure"
      errors.postview_path = error.to_s
      throw(:halt, [401, erb(:build)])
    end
  end

end # class Postview::Application::Build

