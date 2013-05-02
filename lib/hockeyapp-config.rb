require 'hockeyapp'

class HockeyAppConfig
  PROPERTIES = HockeyApp::Version::ATTRIBUTES + HockeyApp::Version::POST_PAYLOAD + [:app_id, :api_token]
  attr_accessor *PROPERTIES

  # Coerce these values to be :symbols
  [["NOTES_TYPES", "notes_type"], ["STATUS","status"]].each do |constant, prop|
    # i.e. Hockey::Version::NOTES_TYPE_TO_SYM
    constant = HockeyApp::Version.const_get(constant + "_TO_SYM")
    define_method("#{prop}=") do |new_value|
      if new_value.is_a?(Numeric)
        new_value = constant[new_value]
      end
      instance_variable_set("@#{prop}", new_value.to_sym)
    end
  end

  def notify=(notify)
    @notify = string_or_num_to_bool(notify)
  end

  def mandatory=(mandatory)
    @mandatory = string_or_num_to_bool(mandatory)
  end

  def initialize(config)
    @config = config
  end

  def client
    if !api_token
      puts "You need to specify a config.api_token"
      return
    end
    @client ||= HockeyApp.build_client
  end

  def app
    return if !client

    @app ||= HockeyApp::App.from_hash({"public_identifier" => app_id}, client)
  end

  def api_token=(api_token)
    @api_token = api_token
    config_client
    @api_token
  end

  def inspect
    h = {}
    PROPERTIES.each do |prop|
      h[prop] = self.send(prop)
    end
    h
  end

  # Public: Creates a HockeyApp::Version object from this configuraiton
  #
  # Returns the new HockeyApp::Version object
  def make_version
    version = HockeyApp::Version.new(app, client)
    version.notes = self.notes
    version.notes_type = HockeyApp::Version::NOTES_TYPES_TO_SYM.invert[self.notes_type]
    version.notify = HockeyApp::Version::NOTIFY_TO_BOOL.invert[self.notify]
    version.status = HockeyApp::Version::STATUS_TO_SYM.invert[self.status]
    version.tags = self.tags
    version
  end

  private
  def config_client
    HockeyApp::Config.configure do |config|
      config.token = api_token
    end
  end

  def string_or_num_to_bool(object)
    if object.is_a?(Symbol)
      notify = notify.to_s
    end
    if object.is_a?(String)
      object = (object == "true") ? true : false
    end
    if object.is_a?(Numeric)
      object = HockeyApp::Version::NOTIFY_TO_BOOL[object]
    end
    object
  end
end