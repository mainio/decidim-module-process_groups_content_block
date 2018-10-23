# frozen_string_literal: true

module Decidim
  module ProcessGroupsContentBlock
    module ContentBlocks
      class HighlightedProcessGroupsCell < Decidim::ViewModel
        include Decidim::SanitizeHelper

        delegate :current_organization, to: :controller
        delegate :current_user, to: :controller

        def show
          if highlighted_groups.any?
            render
          end
        end

        def highlighted_groups
          Decidim::ParticipatoryProcesses::OrganizationPrioritizedParticipatoryProcessGroups.new(
            current_organization
          ).query
          .joins(:participatory_processes)
          .where.not(decidim_participatory_processes: { published_at: nil })
          .group('decidim_participatory_process_groups.id')
          .having('COUNT(decidim_participatory_processes.id) > 0')
        end

        def i18n_scope
          "decidim.process_groups_content_block.pages.home.highlighted_process_groups"
        end

        def decidim_participatory_processes
          Decidim::ParticipatoryProcesses::Engine.routes.url_helpers
        end
      end
    end
  end
end
