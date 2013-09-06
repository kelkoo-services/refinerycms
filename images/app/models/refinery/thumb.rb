module Refinery
  class Thumb < Refinery::Core::BaseModel
    set_table_name "refinery_images_thumb"
    attr_accessible :job, :uid

  end

end