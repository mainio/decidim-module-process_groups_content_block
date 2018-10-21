
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "decidim/process_groups_content_block/version"

Gem::Specification.new do |spec|
  spec.name          = "decidim-process_groups_content_block"
  spec.version       = Decidim::ProcessGroupsContentBlock::VERSION
  spec.authors       = ["Antti Hukkanen"]
  spec.email         = ["antti.hukkanen@mainiotech.fi"]

  spec.summary       = "Process groups content block for Decidim."
  spec.description   = "Provides a process groups content block for Decidim."
  spec.homepage      = "https://github.com/mainio/decidim-module-process_groups_content_block"
  spec.license       = "AGPL-3.0"

  spec.files = Dir[
    "{app,config,lib}/**/*",
    "LICENSE-AGPLv3.txt",
    "Rakefile",
    "README.md"
  ]

  spec.require_paths = ["lib"]

  spec.add_dependency "decidim-core", Decidim::ProcessGroupsContentBlock::DECIDIM_VERSION
  spec.add_dependency "decidim-participatory_processes", Decidim::ProcessGroupsContentBlock::DECIDIM_VERSION

  spec.add_development_dependency "decidim-dev", Decidim::ProcessGroupsContentBlock::DECIDIM_VERSION

  # These extra development dependencies are needed for factory loading for the
  # tests
  spec.add_development_dependency "decidim-assemblies", Decidim::ProcessGroupsContentBlock::DECIDIM_VERSION
  spec.add_development_dependency "decidim-comments", Decidim::ProcessGroupsContentBlock::DECIDIM_VERSION
end
