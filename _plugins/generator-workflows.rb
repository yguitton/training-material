# frozen_string_literal: true

require './_plugins/gtn'

module Jekyll
  ##
  # Generators are Jekyll's way to let you generate files at runtime, without needing them to exist on disk.
  #
  # We use generators for lots of purposes, e.g.
  #
  # +Jekyll::Generators::WorkflowPageGenerator+ emits a webpage for every workflow in the GTN
  # +Jekyll::Generators::AuthorPageGenerator+ emits a hall-of-fame entry for every contributor, organisation, and grant listed in our site metadata.
  module Generators

    ##
    # This class generates the GTN's workflow pages.
    class WorkflowPageGenerator < Generator
      safe true

      ##
      # Params
      # +site+:: The site object
      def generate(site)
        Jekyll.logger.info "[GTN/Workflows] Generating workflow pages"
        materials = Gtn::TopicFilter
          .list_all_materials(site)

        # [{"workflow"=>"Calling_variants_in_non-diploid_systems.ga",
        #   "tests"=>true,
        #   "url"=>"https://training.galaxyproject.org/training-material/topics/variant-analysis/tutorials/non-dip/workflows/Calling_variants_in_non-diploid_systems.ga",
        #   "path"=>"topics/variant-analysis/tutorials/non-dip/workflows/Calling_variants_in_non-diploid_systems.ga",
        #   "wfid"=>"variant-analysis-non-dip",
        #   "wfname"=>"calling-variants-in-non-diploid-systems",
        #   "trs_endpoint"=>"https://training.galaxyproject.org/training-material/api/ga4gh/trs/v2/tools/variant-analysis-non-dip/versions/calling-variants-in-non-diploid-systems",
        #   "license"=>nil,
        #   "parent_id"=>"variant-analysis/non-dip",
        #   "topic_id"=>"variant-analysis",
        #   "tutorial_id"=>"non-dip",
        #   "creators"=>[],
        #   "name"=>"Calling variants in non-diploid systems",
        #   "title"=>"Calling variants in non-diploid systems",
        #   "test_results"=>nil,
        #   "modified"=>2024-03-18 12:38:46.293831071 +0100,
        #   "mermaid"=>
        #   "graph_dot"=>
        # }]
        # /api/workflows/#{topic_id}/#{tutorial_id}/#{wfid}/rocrate.zip
        shortlinks = site.data['shortlinks']['id'].invert

        materials.each do |material|
          (material['workflows'] || []).each do |workflow|
            page2 = PageWithoutAFile.new(site, '', '', "#{workflow['path'].gsub(/.ga$/, '.html')}")
            path = File.join('/', workflow['path'].gsub(/.ga$/, '.html'))
            page2.content = nil
            page2.data['title'] = workflow['title']
            page2.data['layout'] = 'workflow'
            page2.data['material'] = material
            page2.data['workflow'] = workflow
            page2.data['js_requirements'] = {'mathjax' => false, 'mermaid' => true}
            page2.data['short_id'] = shortlinks[path]
            page2.data['redirect_from'] = ["/short/#{shortlinks[path]}"]
            site.pages << page2
          end
        end
      end
    end
  end
end

