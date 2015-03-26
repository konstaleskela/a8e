class FormSenderCache < ActiveRecord::Base
  def self.clear_cache
    self.where(['expires < ?', DateTime.now]).destroy_all
  end
end
