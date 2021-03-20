module Pairable
  extend ActiveSupport::Concern

  def unpairable_opponents
    @unpairable_opponents ||= opponents.map { |p| p.id ? p : Swissper::Bye }
  end

  # opponents we cannot corp against again
  def uncorpable_opponents
    @uncorpable_opponents ||= opponents_corped_against.map { |p| p.id ? p : Swissper::Bye }
  end

  # opponents we cannot run against again
  def unrunnerable_opponents
    @unrunnerable_opponents ||= opponents_ran_against.map { |p| p.id ? p : Swissper::Bye }
  end
end
