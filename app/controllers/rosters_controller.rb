# frozen_string_literal: true

class RostersController < ApplicationController
  before_action :ensure_student_identifier_flipper_is_enabled, :set_organization
<<<<<<< HEAD
  before_action :set_roster, :set_unlinked_users, only: [:show]
=======
  before_action :set_roster, only: [:show]
>>>>>>> refs/remotes/origin/roster_management_page

  def show; end

  def new
    @roster = Roster.new
  end

  def create
    @roster = Roster.new(identifier_name: params[:identifier_name])
    @roster.save!

    add_identifiers_to_roster

    @organization.roster = @roster
    @organization.save!

    flash[:success] = 'Your classroom roster has been saved! Manage it HERE' # TODO: ADD LINK TO MANAGE PAGE

    redirect_to organization_path(@organization)
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  private

  def set_organization
    @organization = Organization.find_by!(slug: params[:id])
  end

  def set_roster
    @roster = @organization.roster
  end

<<<<<<< HEAD
  # An unlinked user is a user who:
  # - Is a user on an assignment or group assignment belonging to the org
  # - Is not on the organization roster
  def set_unlinked_users
    group_assignment_users = @organization.repo_accesses.map(&:user)
    assignment_users = @organization.assignments.map(&:users).flatten.uniq

    roster_entry_users = @roster.roster_entries.map(&:user).compact

    @unlinked_users = (group_assignment_users + assignment_users).uniq - roster_entry_users
  end

=======
>>>>>>> refs/remotes/origin/roster_management_page
  def add_identifiers_to_roster
    identifiers = split_identifiers(params[:identifiers])
    identifiers.each do |identifier|
      @roster.roster_entries << RosterEntry.create(identifier: identifier)
    end
  end

  def split_identifiers(raw_identifiers_string)
    raw_identifiers_string.split("\r\n").reject(&:empty?).uniq
  end
end
