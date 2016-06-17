class Ability
  include CanCan::Ability

  def initialize(user)

    return if user.nil?

    if user.admin?
      can :manage, :all
    elsif user.customer?
      can [:create, :read, :update], Comment, :ticket => { :customer_id => user.profile_id }
      can :create, Ticket
      can [:read, :update], Ticket, :customer_id => user.profile_id
      can :update, Customer, :id => user.profile_id
      can [:read, :update], Account, :id => user.id
    end

  end
end