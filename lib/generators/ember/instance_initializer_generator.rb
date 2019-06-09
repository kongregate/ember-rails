require 'generators/ember/generator_helpers'

module Ember
  module Generators
    class InstanceInitializerGenerator < ::Rails::Generators::NamedBase
      include Ember::Generators::GeneratorHelpers

      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a new Ember.js instance initializer"

      class_option :javascript_engine, :desc => "Engine for JavaScripts"
      class_option :ember_path, :type => :string, :aliases => "-d", :desc => "Custom ember app path"
      class_option :app_name, :type => :string, :aliases => "-n", :desc => "Custom ember app name"

      def create_instance_initializer_files
        file_path = File.join(ember_path, 'instance-initializers', class_path, "#{file_name.dasherize}.#{engine_extension}")

        template "instance-initializer.#{engine_extension}", file_path
      end
    end
  end
end
