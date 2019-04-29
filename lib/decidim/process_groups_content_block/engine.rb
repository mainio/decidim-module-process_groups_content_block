# frozen_string_literal: true

module Decidim
  module ProcessGroupsContentBlock
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::ProcessGroupsContentBlock

      initializer "decidim_process_groups_content_block.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::ProcessGroupsContentBlock::Engine.root}/app/cells")
      end

      initializer "decidim_process_groups_content_block.content_blocks" do
        Decidim.content_blocks.register(:homepage, :highlighted_process_groups) do |content_block|
          content_block.cell = "decidim/process_groups_content_block/content_blocks/highlighted_process_groups"
          content_block.public_name_key = "decidim.process_groups_content_block.content_blocks.highlighted_process_groups.name"
        end
      end
    end
  end
end
