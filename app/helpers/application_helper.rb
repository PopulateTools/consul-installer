module ApplicationHelper
  def web_servers
    servers_list('web')
  end

  def app_servers
    servers_list('app')
  end

  def db_servers
    servers_list('db')
  end

  def servers_list(server_type)
    specific_servers = case server_type
    when 'web' then Server.web_servers
    when 'app' then Server.app_servers
    when 'db' then Server.db_servers
    end

    (specific_servers + Server.full_stack_servers).map{|s| [s.name, s.id]}
  end
end
