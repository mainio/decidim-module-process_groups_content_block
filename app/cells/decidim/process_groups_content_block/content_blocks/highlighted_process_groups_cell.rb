# frozen_string_literal: true

module Decidim
  module ProcessGroupsContentBlock
    module ContentBlocks
      class HighlightedProcessGroupsCell < Decidim::ViewModel
        include Decidim::ApplicationHelper # html_truncate
        include Decidim::LayoutHelper # If icons are needed in the (customized) view
        include Decidim::SanitizeHelper # decidim_sanitize

        delegate :current_organization, to: :controller
        delegate :current_user, to: :controller

        def show
          render if highlighted_groups.any?
        end

        def highlighted_groups
          Decidim::ParticipatoryProcesses::OrganizationPrioritizedParticipatoryProcessGroups
            .new(current_organization)
            .query
            .joins(:participatory_processes)
            .where.not(decidim_participatory_processes: { published_at: nil })
            .where(
              "decidim_participatory_processes.end_date IS NULL "\
              "OR decidim_participatory_processes.end_date > ?",
              Time.current
            )
            .group("decidim_participatory_process_groups.id")
            .having("COUNT(decidim_participatory_processes.id) > 0")
        end

        def i18n_scope
          "decidim.process_groups_content_block.pages.home.highlighted_process_groups"
        end

        def decidim_participatory_processes
          Decidim::ParticipatoryProcesses::Engine.routes.url_helpers
        end

        private

        def title_for(group)
          translated_attribute(group.name)
        end

        def description_for(group)
          text = translated_attribute(group.description)
          decidim_sanitize(html_truncate(text, length: 100))
        end
      end
    end
  end
end
