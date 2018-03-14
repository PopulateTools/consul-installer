require 'test_helper'

class SitesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @site = sites(:one)
    log_in_as(users(:one))
  end

  test "should get index" do
    get sites_url
    assert_response :success
  end

  test "should get new" do
    get new_site_url
    assert_response :success
  end

  test "should create site" do
    assert_difference('Site.count') do
      post sites_url, params: { site: { app_server_id: servers(:one).id, web_server_id: servers(:one).id, db_server_id: servers(:one).id, base_path: "site03", db_password: "12345678", db_user: "site03", host: "site03.example.com", name: "site03", rails_env: "production", secret_key_base: "1234567890", repo_url: "https://github.com/PopulateTools/consul-consul.git" } }
    end

    assert_redirected_to site_setup_url(Site.last, Site.last.site_setups.last)
  end

  test "should show site" do
    get site_url(@site)
    assert_response :success
  end

  test "should get edit" do
    get edit_site_url(@site)
    assert_response :success
  end

  test "should update site" do
    patch site_url(@site), params: { site: { app_server: @site.app_server, base_path: @site.base_path, db_password: @site.db_password, db_server: @site.db_server, db_user: @site.db_user, host: @site.host, name: @site.name, rails_env: @site.rails_env, secret_key_base: @site.secret_key_base, web_server: @site.web_server, repo_url: "https://github.com/PopulateTools/consul-consul.git" } }
    assert_redirected_to site_url(@site)
  end

  test "should destroy site" do
    assert_difference('Site.count', -1) do
      delete site_url(@site)
    end

    assert_redirected_to sites_url
  end
end
