ActiveAdmin.register Ad do
  menu :parent => "bPOP Pages", :label => 'Ads'

  permit_params :content, :active, :page_slug

  before_filter :only => [:show, :destroy, :edit, :update] do
    @titles = ["home"] + Page.all.pluck(:slug)
  end


  form do |f|
    f.inputs "Ad Details" do
      f.input :page_slug, :required => true, collection: ["home", "blog"] + Page.all.pluck(:slug)
      f.input :active, :label => "Active", :required => true
      f.input :content, :as => :rich, :allow_embeds => true, :required => true
    end
    f.actions
  end



  show do
    attributes_table do
      row :page_slug
      row :content do |ad|
        simple_format(ad.content.gsub(/\\r\\n/, ""),  {},  sanitize: false)
        # ad.content.html_safe
      end
    end
    active_admin_comments
  end

  
end
