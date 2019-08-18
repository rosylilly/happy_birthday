class PagesController < ApplicationController
  def root
    @latest = Character.order(updated_at: :desc).first
    @last_modified = @latest.updated_at

    render if stale?(@latest, public: true)
  end
end
