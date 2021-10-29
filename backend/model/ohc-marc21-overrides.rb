class MARCModel < ASpaceExport::ExportModel
  model_for :marc21

  include JSONModel

  #don't export empty fields when using df_handler
  def self.df_handler(name, tag, ind1, ind2, code)
    define_method(name) do |val|
      if val
        df(tag, ind1, ind2).with_sfs([code, val])
      end
    end
    name.to_sym
  end
  
	@resource_map = {
    [:id_0, :id_1, :id_2, :id_3] => :handle_id,
    [:ead_location] => :handle_ead_loc,
    [:ark_name] => :handle_ark,
    [:uri] => :handle_public_url,
    :notes => :handle_notes,
    :finding_aid_description_rules => df_handler('fadr', '040', ' ', ' ', 'e')
  }

  def handle_public_url(uri)
    if uri && !uri.empty?
			public_url = "https://aspace.ohiohistory.org" << uri
      df!('856', '4', '2').with_sfs(
                                    ['z', "View record in ArchivesSpace:"],
                                    ['u', public_url]
                                  )
    end
  end

end
