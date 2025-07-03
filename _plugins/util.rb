require 'yaml'

# This module specifically avoids having any dependencies. If you have a method
# that needs to be used in many places, even those without initialisation, it
# should go here.

ALLOWED_SHORT_IDS = [
  'addValue',
  'aggregate_scores_in_intervals2',
  'axt_to_concat_fasta',
  'axt_to_fasta',
  'axt_to_lav_1',
  'barchart_gnuplot',
  'bed2gff1',
  'bed_to_bigBed',
  'bfast_wrapper',
  'bgchem_fragment_merger',
  'bg_protein_properties',
  'bigwigtowig',
  'biomart',
  'biomart_test',
  'biopython_base_distribution',
  'blockbuster',
  'bwtool-lift',
  'cat1',
  'cbi_rice_mart',
  'ChangeCase',
  'codon_count',
  'comp1',
  'concatenate_icenet_data',
  'Convert characters1',
  'CONVERTER_archive_to_directory',
  'CONVERTER_Bam_Bai_0',
  'CONVERTER_bam_to_bigwig_0',
  'CONVERTER_bam_to_coodinate_sorted_bam',
  'CONVERTER_bam_to_qname_sorted_bam',
  'CONVERTER_bcf_uncompressed_to_bcf',
  'CONVERTER_bed_gff_or_vcf_to_bigwig_0',
  'CONVERTER_bedgraph_to_bigwig',
  'CONVERTER_bed_to_fli_0',
  'CONVERTER_bed_to_gff_0',
  'CONVERTER_biom',
  'CONVERTER_bz2_to_uncompressed',
  'CONVERTER_cml_to_smiles',
  'CONVERTER_cram_to_bam_0',
  'CONVERTER_fasta_to_2bit',
  'CONVERTER_fasta_to_bowtie_base_index',
  'CONVERTER_fasta_to_bowtie_color_index',
  'CONVERTER_fasta_to_fai',
  'CONVERTER_fasta_to_len',
  'CONVERTER_fasta_to_tabular',
  'CONVERTER_fastq_to_fqtoc0',
  'CONVERTER_gff_to_bed_0',
  'CONVERTER_gff_to_fli_0',
  'CONVERTER_gff_to_interval_index_0',
  'CONVERTER_Gro_to_Pdb_0',
  'CONVERTER_gz_to_uncompressed',
  'CONVERTER_inchi_to_mol',
  'CONVERTER_interval_to_bed_0',
  'CONVERTER_interval_to_bed12_0',
  'CONVERTER_interval_to_bed6_0',
  'CONVERTER_interval_to_bedstrict_0',
  'CONVERTER_interval_to_bgzip_0',
  'CONVERTER_interval_to_bigwig_0',
  'CONVERTER_interval_to_tabix_0',
  'CONVERTER_len_to_linecount',
  'CONVERTER_maf_to_fasta_0',
  'CONVERTER_maf_to_interval_0',
  'CONVERTER_mdconvert',
  'CONVERTER_mol2_to_mol',
  'CONVERTER_molecules',
  'CONVERTER_neostorezip_to_neostore',
  'CONVERTER_parquet_to_csv',
  'CONVERTER_Pdb_to_Gro_0',
  'CONVERTER_picard_interval_list_to_bed6',
  'CONVERTER_ref_to_seq_taxomony',
  'CONVERTER_sam_to_bigwig_0',
  'CONVERTER_sam_to_unsorted_bam',
  'CONVERTER_SMILES_to_MOL',
  'CONVERTER_smiles_to_smiles',
  'CONVERTER_uncompressed_to_gz',
  'CONVERTER_vcf_bgzip_to_tabix_0',
  'CONVERTER_wiggle_to_interval_0',
  'CONVERTER_wig_to_bigwig',
  'Count1',
  'create_API_requests_for_icenet_data',
  'createInterval',
  'csv_to_tabular',
  'Cut1',
  'diced_database',
  'ds_seek_test',
  'ebi_sra_main',
  'eupathdb',
  'export_remote',
  'Extract_features1',
  'Filter1',
  'flymine',
  'fragmenter',
  'gbk_to_orf',
  'genbank_to_gff',
  'gene2exon1',
  'GeneBed_Maf_Fasta2',
  'gff2bed1',
  'gff_filter_by_attribute',
  'gff_filter_by_feature_count',
  'gff_to_sequence',
  'gramenemart',
  'Grep1',
  'Grouping1',
  'gtf2bedgraph',
  'gtf_filter_by_attribute_values_list',
  'hbvar',
  'hgv_beam',
  'hgv_david',
  'hgv_gpass',
  'hgv_ldtools',
  'hgv_linkToGProfile',
  'hgv_lps',
  'hgv_pass',
  'icenet_forecast',
  'interactive_tool_anylabeling',
  'interactive_tool_askomics',
  'interactive_tool_audiolabeler',
  'interactive_tool_bam_iobio',
  'interactive_tool_bellavista',
  'interactive_tool_blobtoolkit',
  'interactive_tool_cellpose',
  'interactive_tool_cellprofiler',
  'interactive_tool_cellxgene',
  'interactive_tool_cellxgene_vip',
  'interactive_tool_climate_notebook',
  'interactive_tool_copasi',
  'interactive_tool_copernicus_notebook',
  'interactive_tool_divand',
  'interactive_tool_escriptorium',
  'interactive_tool_ethercalc',
  'interactive_tool_genenotebook',
  'interactive_tool_geoexplorer',
  'interactive_tool_hdfview',
  'interactive_tool_higlass',
  'interactive_tool_holoviz',
  'interactive_tool_ideal',
  'interactive_tool_ilastik',
  'interactive_tool_isee',
  'interactive_tool_jupytergis_notebook',
  'interactive_tool_jupyter_notebook',
  'interactive_tool_libertem',
  'interactive_tool_metashark',
  'interactive_tool_metashrimps',
  'interactive_tool_mgnify_notebook',
  'interactive_tool_ml_jupyter_notebook',
  'interactive_tool_napari',
  'interactive_tool_neo4j',
  'interactive_tool_odv',
  'interactive_tool_openrefine',
  'interactive_tool_pampa',
  'interactive_tool_pangeo_ml_notebook',
  'interactive_tool_pangeo_notebook',
  'interactive_tool_panoply',
  'interactive_tool_paraview',
  'interactive_tool_pavian',
  'interactive_tool_pcstudio',
  'interactive_tool_phinch',
  'interactive_tool_phyloseq',
  'interactive_tool_pyiron',
  'interactive_tool_qgis',
  'interactive_tool_qiskit_jupyter_notebook',
  'interactive_tool_qupath',
  'interactive_tool_radiant',
  'interactive_tool_rstudio',
  'interactive_tool_rstudio_askor',
  'interactive_tool_scoop3_argo',
  'interactive_tool_simtext_app',
  'interactive_tool_source',
  'interactive_tool_stac',
  'interactive_tool_tadviewer',
  'interactive_tool_terriamap',
  'interactive_tool_vcf_iobio',
  'interactive_tool_vrm_editor',
  'interactive_tool_wallace',
  'interactive_tool_wilson',
  'interactive_zeppelin_notebook',
  'intermine',
  'Interval2Maf1',
  'Interval2Maf_pairwise1',
  'Interval_Maf_Merged_Fasta2',
  'join1',
  'lav_to_bed1',
  'lftp',
  'liftOver1',
  'lped2fpedconvert',
  'lped2pbedconvert',
  'maf_by_block_number1',
  'MAF_filter',
  'maf_limit_size1',
  'MAF_Limit_To_Species1',
  'MAF_Reverse_Complement_1',
  'MAF_split_blocks_by_species1',
  'maf_stats1',
  'MAF_Thread_For_Species1',
  'MAF_To_BED1',
  'MAF_To_Fasta1',
  'MAF_To_Interval1',
  'master2pgSnp',
  'metabolicmine',
  'microbial_import1',
  'modENCODEfly',
  'modENCODEworm',
  'modmine',
  'mosaik_wrapper',
  'mousemine',
  'ncbi_datasets_source',
  'netcdf2zarr',
  'omicsdi',
  'param_value_from_file',
  'Paste1',
  'pbed2ldindepconvert',
  'pbed2lpedconvert',
  'pcgr',
  'PerM',
  'preprocess_icenet_data',
  'proteomics_search_interprophet_1',
  'proteomics_search_peptide_prophet_1',
  'proteomics_search_protein_prophet_1',
  'proteomics_search_tandem_1',
  'proteomics_search_tandem_2',
  'pyiron_meta',
  'qual_stats_boxplot',
  'random_lines1',
  'ratmine',
  'Remove beginning1',
  'rnalfoldz',
  'secure_hash_message_digest',
  'sequence_convert',
  'Sff_extractor',
  'Show beginning1',
  'Show tail1',
  'snpSift_geneSets',
  'solid2fastq',
  'solid_qual_boxplot',
  'solid_qual_stats',
  'sort1',
  'sra_source',
  'srma_wrapper',
  'Summary_Statistics1',
  'tabular_to_csv',
  'tabular_to_dbnsfp',
  'terrabyte_ogc_api_processes',
  'tombo_detect_modifications',
  'tombo_plot_genome_locations',
  'tombo_plot_most_significant',
  'tombo_resquiggle',
  'tombo_text_output',
  'translate_nucleotides',
  'trimmer',
  'ucsc_bigbedtobed',
  'ucsc_table_direct1', # This does not work, surprisingly.
  'ucsc_table_direct_archaea1',
  'upload1',
  'vcf_to_maf_customtrack1',
  'velvetg',
  'velveth',
  'visualize_icenet_forecast',
  'wc_gnu',
  'wiggle2simple1',
  'wig_to_bigWig',
  'wormbase',
  'yeastmine',
  'zebrafishmine'
].freeze

ALLOWED_LOWER_SHORT_IDS = ALLOWED_SHORT_IDS.map(&:downcase)

def safe_load_yaml(file)
  YAML.load_file(file)
rescue StandardError
  YAML.load_file(file, permitted_classes: [Date])
end

def collapse_event_date_pretty(event)
  s = event['date_start']
  e = if event['date_end'].nil?
        s
      else
        event['date_end']
      end
  # want dates like "Mar 22-25, 2024" or "Mar 22-May 1, 2024"
  dash = ' – ' # thin space, en dash, thin space
  if s.year == e.year
    if s.month == e.month
      if s.day == e.day
        "#{s.strftime('%B')} #{s.day}, #{s.year}"
      else
        "#{s.strftime('%B')} #{s.day}#{dash}#{e.day}, #{s.year}"
      end
    else
      "#{s.strftime('%B')} #{s.day}#{dash}#{e.strftime('%B')} #{e.day}, #{s.year}"
    end
  else
    "#{s.strftime('%B')} #{s.day}, #{s.year}#{dash}#{e.strftime('%B')} #{e.day}, #{e.year}"
  end
end

def safe_site_config(site, key, default)
  if !site.config.nil? && site.config.key?(key)
    site.config[key]
  else
    default
  end
end


def url_prefix(site)
  if !site.config.nil? && site.config.key?('url')
    "#{site.config['url']}#{site.config['baseurl']}"
  else
    'http://localhost:4000/training-material/'
  end
end

def markdownify(site, text)
  site.find_converter_instance(
    Jekyll::Converters::Markdown
  ).convert(text.to_s)
end

def unsafe_slugify(text)
  text.gsub(%r{["'\\/;:,.!@#$%^&*()]}, '').gsub(/\s/, '-').gsub(/-+/, '-')
end

def fix_version(version)
  version
  .gsub('_beta+galaxy', '+galaxy')
  .gsub(/^([0-9]+)_([0-9]+)_([0-9]+)\+galaxy(.+)/, '\1.\2.\3galaxy\4')
  .gsub(/^([0-9]+)\+galaxy(.+)/, '\1.0.0galaxy\2')
  .gsub(/^([0-9.]+)_([0-9]+)/, '\1galaxy\2')
  .gsub(/_rc(.*)galaxy/, 'rc\1galaxy')
  .gsub('+', '')
  .gsub(/^v/, '')
end

def acceptable_tool?(tool_id)
  if ! tool_id.is_a?(String)
    return false
  end

  # Public TS links are fine
  if tool_id.start_with?('toolshed.g2.bx.psu.edu')
    return true
  end

  # These are always allowed (mostly built-ins)
  if ALLOWED_LOWER_SHORT_IDS.include?(tool_id.downcase) || tool_id =~ /^__.*__$/
    return true
  end

  if tool_id.start_with?('interactive_tool_')
    return true
  end

  if tool_id.start_with?('CONVERTER_')
    return true
  end

  # Templated tool IDs are hopefully fine!
  if tool_id.start_with?('{{')
    return true
  end

  # Just the tutorial
  if tool_id.start_with?('Toolshed ID')
    return true
  end

  # Unacceptable
  return false
end


def tool_id_extractor(wf, path: [])
  res = []
  wf['steps'].each do |step_id, step|
    if step.key?('subworkflow')
      res += tool_id_extractor(step['subworkflow'], path: path + [step_id])
    elsif step.key?('tool_id') && ! step['tool_id'].nil?
      res.push(["#{path.join('/')}/#{step_id}", step['tool_id']])
    end
  end
  res
end

def objectify(attrs, url, path)
  obj = attrs.clone
  obj['__path'] = path
  obj['__url'] = url

  def obj.data
    self
  end

  def obj.path
    self['__path']
  end

  def obj.url
    self['__url']
  end

  def obj.content
    self.fetch('content', 'NO CONTENT AVAILABLE')
  end

  def obj.title
    self['title']
  end

  obj
end

if __FILE__ == $PROGRAM_NAME
  require 'test/unit'
    # Testing for the class
  class Gtn::Test::IntersectionTest < Test::Unit::TestCase
    def test_bad_versions
      # toolshed.g2.bx.psu.edu/repos/wolma/mimodd_main/mimodd_info/0.1.8_1
      assert_equal(fix_version("0.1.8_1"), "0.1.8galaxy1")

      # toolshed.g2.bx.psu.edu/repos/iuc/snap_training/snap_training/2013_11_29+galaxy1
      assert_equal(fix_version("2013_11_29+galaxy1"), "2013.11.29galaxy1")

      # toolshed.g2.bx.psu.edu/repos/devteam/vcffilter/vcffilter2/1.0.0_rc1+galaxy3
      assert_equal(fix_version("1.0.0_rc1+galaxy3"), "1.0.0rc1galaxy3")

      #
      assert_equal(fix_version("3+galaxy0"), "3.0.0galaxy0")
    end
  end
end
