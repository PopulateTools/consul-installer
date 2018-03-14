class ActivityController < ApplicationController
  def index
    @audits = Audited::Audit.all #TODO: paginate audits
  end
end
