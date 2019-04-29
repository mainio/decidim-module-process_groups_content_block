# frozen_string_literal: true

module Decidim
  module ProcessGroupsContentBlock
    # This query class filters participatory process groups given an organization and a filter.
    class OrganizationActiveParticipatoryProcessGroups < Decidim::ParticipatoryProcesses::OrganizationPrioritizedParticipatoryProcessGroups
      def query
        ids = super
              .joins(:participatory_processes)
              .where.not(decidim_participatory_processes: { published_at: nil })
              .where(
                "decidim_participatory_processes.end_date IS NULL "\
                "OR decidim_participatory_processes.end_date > ?",
                Time.current
              )
              .group("decidim_participatory_process_groups.id")
              .having("COUNT(decidim_participatory_processes.id) > 0")
              .pluck(:id)

        Decidim::ParticipatoryProcessGroup
          .where(id: ids)
          .order(Arel.sql("name ->> '#{current_locale}' ASC"))
      end

      private

      def current_locale
        I18n.locale.to_s
      end
    end
  end
end
