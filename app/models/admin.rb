class Admin < ActiveRecord::Base
  include HavingAccount

  def destroy
    raise "You can't delete superadmin's account!" if is_super
    super
  end
end
