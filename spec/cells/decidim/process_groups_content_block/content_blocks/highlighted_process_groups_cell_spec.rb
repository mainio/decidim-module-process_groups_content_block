# frozen_string_literal: true

require "spec_helper"

describe Decidim::ProcessGroupsContentBlock::ContentBlocks::HighlightedProcessGroupsCell, type: :cell do
  subject { cell(content_block.cell, content_block).call }

  let(:organization) { create :organization }
  let(:content_block) { create :content_block, organization: organization, manifest_name: :highlighted_process_groups, scope_name: :homepage }

  let!(:local_participatory_process_groups) do
    create_list(:participatory_process_group, 5, organization: organization)
  end

  let!(:foreign_participatory_process_groups) do
    create_list(:participatory_process_group, 5)
  end

  controller Decidim::PagesController

  before do
    allow(controller).to receive(:current_organization).and_return(organization)
  end

  context "when there are process groups without any processes" do
    it "does not show the process groups" do
      expect(subject).not_to have_selector "#highlighted-process-groups"
    end
  end

  context "when there are process groups without any published processes" do
    before do
      local_participatory_process_groups.each do |group|
        # Create only processes currently unpublished to all process groups
        create_list(
          :participatory_process,
          5,
          organization: organization,
          participatory_process_group: group,
          published_at: nil
        )
      end
    end

    it "does not show the process groups" do
      expect(subject).not_to have_selector "#highlighted-process-groups"
    end
  end

  context "when there are process groups with active processes" do
    before do
      past_start_date = Date.current - 11.days
      past_end_date = Date.current - 1.day

      local_participatory_process_groups.each_with_index do |group, i|
        if i < 2
          # Add only processes in the past to two process groups
          create_list(
            :participatory_process,
            5,
            organization: organization,
            participatory_process_group: group,
            start_date: past_start_date,
            end_date: past_end_date
          )
        else
          # Add only processes currently active to two process groups
          create_list(
            :participatory_process,
            5,
            organization: organization,
            participatory_process_group: group
          )
        end
      end
    end

    it "shows the process groups element" do
      expect(subject).to have_selector "#highlighted-process-groups"
    end

    it "shows the local process groups" do
      target = subject.find("#highlighted-process-groups")

      expect(target).to have_selector(
        "article.card--process.card--stack",
        count: local_participatory_process_groups.count - 2
      )
    end
  end

  context "when there are process groups with active processes with nil end date" do
    before do
      local_participatory_process_groups.each_with_index do |group, i|
        # Add only processes currently active to two process groups
        next if i >= 2

        # Mark end date as nil (i.e. always active)
        create_list(
          :participatory_process,
          5,
          organization: organization,
          participatory_process_group: group,
          end_date: nil
        )
      end
    end

    it "shows the process groups element" do
      expect(subject).to have_selector "#highlighted-process-groups"
    end

    it "shows the local process groups" do
      target = subject.find("#highlighted-process-groups")

      expect(target).to have_selector(
        "article.card--process.card--stack",
        count: 2
      )
    end
  end

  # Inactive processes do not currently cause the process groups to disappear
  # from the list because the "active" filtering for the process groups does
  # not take this into account as shown in:
  # https://github.com/decidim/decidim/blob/74c6d1a/decidim-participatory_processes/app/queries/decidim/participatory_processes/filtered_participatory_process_groups.rb#L16-L23
  #
  # We are using a filter with key "active" as shown in:
  # https://github.com/decidim/decidim/blob/74c6d1a/decidim-participatory_processes/app/queries/decidim/participatory_processes/organization_prioritized_participatory_process_groups.rb#L7
  #
  # Therefore, it should currently fetch all the process groups as defined by
  # the Decidim core.
  #
  # NOTE:
  # In the future this may have to be changed.
  context "when there are process groups with only inactive processes" do
    before do
      past_start_date = Date.current - 11.days
      past_end_date = Date.current - 1.day

      future_start_date = Date.current + 1.day
      future_end_date = Date.current + 11.days

      local_participatory_process_groups.each_with_index do |group, i|
        if i < 2
          # Add only processes in the past to two process groups
          create_list(
            :participatory_process,
            5,
            organization: organization,
            participatory_process_group: group,
            start_date: past_start_date,
            end_date: past_end_date
          )
        else
          # Add only processes in the future to two process groups
          create_list(
            :participatory_process,
            5,
            organization: organization,
            participatory_process_group: group,
            start_date: future_start_date,
            end_date: future_end_date
          )
        end
      end
    end

    it "shows the process groups element" do
      expect(subject).to have_selector "#highlighted-process-groups"
    end

    it "shows the local process groups" do
      target = subject.find("#highlighted-process-groups")

      expect(target).to have_selector(
        "article.card--process.card--stack",
        count: local_participatory_process_groups.count - 2
      )
    end
  end
end
