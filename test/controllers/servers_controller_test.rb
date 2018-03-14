require 'test_helper'

class ServersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @server = servers(:one)
    log_in_as(users(:one))
  end

  test "should get index" do
    get servers_url
    assert_response :success
  end

  test "should get new" do
    get new_server_url
    assert_response :success
  end

  test "should create server" do
    assert_difference('Server.count') do
      post servers_url, params: { server: { ip: "9.9.9.9", name: "#{@server.name}_2", server_type: @server.server_type } }
    end

    assert_redirected_to server_setup_url(Server.last, Server.last.server_setups.last)
  end

  test "should show server" do
    get server_url(@server)
    assert_response :success
  end

  test "should get edit" do
    get edit_server_url(@server)
    assert_response :success
  end

  test "should update server" do
    patch server_url(@server), params: { server: { ip: @server.ip, name: "#{@server.name}_2", server_type: @server.server_type } }
    assert_redirected_to server_url(@server)
  end

  test "should destroy server" do
    assert_difference('Server.count', -1) do
      delete server_url(servers(:three))
    end

    assert_redirected_to servers_url
  end
end
