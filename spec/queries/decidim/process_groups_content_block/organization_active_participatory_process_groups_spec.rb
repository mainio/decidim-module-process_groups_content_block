# frozen_string_literal: true

require "spec_helper"

module Decidim::ProcessGroupsContentBlock
  describe OrganizationActiveParticipatoryProcessGroups do
    subject { described_class.new(organization) }

    let!(:organization) { create(:organization) }

    describe "#query" do
      let!(:local_participatory_process_groups) do
        create_list(:participatory_process_group, 5, organization: organization)
      end

      let!(:foreign_participatory_process_groups) do
        create_list(:participatory_process_group, 5)
      end

      it "orders by group names" do
        # Define the names explicitly because sort algorithms differ in Ruby
        # and PostgreSQL. Therefore, we need to know exactly what order to
        # expect from the DB.
        names = [
          "Abc starts the alphabet",
          "Def continues after that",
          "Ghi is the end of our list"
        ]

        names.each do |name|
          group = create(
            :participatory_process_group,
            organization: organization,
            name: organization.available_locales.map { |l| [l.to_s, name] }.to_h
          )
          create(
            :participatory_process,
            :active,
            :published,
            organization: organization,
            participatory_process_group: group
          )
        end

        expect(subject.pluck(:name).map { |n| n[I18n.locale.to_s] }).to eq(names)
      end

      context "when there are only process groups without any processes" do
        it "does not return any process groups" do
          expect(subject.count).to eq(0)
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

        it "does not return any process groups" do
          expect(subject.count).to eq(0)
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

        it "returns correct number of process groups" do
          expect(subject.count).to eq(3)
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

        it "returns correct number of process groups" do
          expect(subject.count).to eq(2)
        end
      end

      context "when there are process groups with inactive processes" do
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

        it "returns correct number of process groups" do
          expect(subject.count).to eq(3)
        end
      end
    end
  end
end
