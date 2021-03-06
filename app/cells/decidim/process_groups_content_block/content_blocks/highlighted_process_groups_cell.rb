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
          OrganizationActiveParticipatoryProcessGroups
            .new(current_organization)
            .query
        end

        def i18n_scope
          "decidim.process_groups_content_block.pages.home.highlighted_process_groups"
        end

        def decidim_participatory_processes
          Decidim::ParticipatoryProcesses::Engine.routes.url_helpers
        end

        private

        def title_for(group)
          translated_attribute(group.title)
        end

        def description_for(group)
          text = translated_attribute(group.description)
          decidim_sanitize(html_truncate(text, length: 100))
        end
      end
    end
  end
end
