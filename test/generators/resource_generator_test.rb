require 'test_helper'
require 'generators/ember/resource_generator'

class ResourceGeneratorTest < Rails::Generators::TestCase
  tests Ember::Generators::ResourceGenerator
  destination File.join(Rails.root, "tmp", "generator_test_output")
  setup :prepare_destination


  %w(js coffee em).each do |engine|

    test "create view with #{engine} engine" do
      run_generator ["post", "--javascript-engine=#{engine}"]
      assert_file "app/assets/javascripts/views/post_view.js.#{engine}".sub('.js.js','.js'), /templateName: 'post'/
    end

    test "create template with #{engine} engine" do
      run_generator ["post", "--javascript-engine=#{engine}"]
      assert_file "app/assets/javascripts/templates/post.hbs"
    end

    test "create controller with #{engine} engine" do
      run_generator ["post", "--javascript-engine=#{engine}"]
      assert_file "app/assets/javascripts/controllers/post_controller.js.#{engine}".sub('.js.js','.js')
    end

    test "create route with #{engine} engine" do
      run_generator ["post", "--javascript-engine=#{engine}"]
      assert_file "app/assets/javascripts/routes/post_route.js.#{engine}".sub('.js.js','.js')
    end

    test "skip route with #{engine} engine" do
      run_generator ["post", "--javascript-engine=#{engine}", "--skip-route"]
      assert_no_file "app/assets/javascripts/routes/post_route.js.#{engine}".sub('.js.js','.js')
    end

    test "create all with #{engine} engine and custom name" do
      run_generator ["post", "--javascript-engine=#{engine}", "-n", "MyApp"]
      assert_file "app/assets/javascripts/views/post_view.js.#{engine}".sub('.js.js','.js'), /MyApp.PostView/
      assert_file "app/assets/javascripts/controllers/post_controller.js.#{engine}".sub('.js.js','.js'), /MyApp\.PostController/
      assert_file "app/assets/javascripts/routes/post_route.js.#{engine}".sub('.js.js','.js'), /MyApp\.PostRoute/
    end
  end

  test "Uses config.ember.app_name as the app name" do
    begin
      old, ::Rails.configuration.ember.app_name = ::Rails.configuration.ember.app_name, 'MyApp'

      run_generator %w(post)
      assert_file "app/assets/javascripts/views/post_view.js", /MyApp.PostView/
      assert_file "app/assets/javascripts/controllers/post_controller.js", /MyApp\.PostController/
      assert_file "app/assets/javascripts/routes/post_route.js", /MyApp\.PostRoute/
    ensure
      ::Rails.configuration.ember.app_name = old
    end
  end

  test "Uses config.ember.ember_path" do
    begin
      custom_path = ember_path("custom")
      old, ::Rails.configuration.ember.ember_path = ::Rails.configuration.ember.ember_path, custom_path

      run_generator ["post"]
      assert_file "#{custom_path}/views/post_view.js"
      assert_file "#{custom_path}/controllers/post_controller.js"
      assert_file "#{custom_path}/routes/post_route.js"
    ensure
      ::Rails.configuration.ember.ember_path = old
    end
  end

  private

  def ember_path(custom_path = nil)
   "app/assets/javascripts/#{custom_path}".chomp('/')
  end
end

