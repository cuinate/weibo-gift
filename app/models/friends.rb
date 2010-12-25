class Friends < ActiveRecord::Base
  require 'will_paginate'
  belongs_to :user
  cattr_reader :per_page
  @@per_page = 50
end
