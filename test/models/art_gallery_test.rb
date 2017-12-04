require 'test_helper'

class ArtGalleryTest < ActiveSupport::TestCase
  test "should not be valid without any file" do
    art_gallery = ArtGallery.new(nil, nil)
    assert_not art_gallery.valid?
  end

  test "should not be valid for files other than text" do
    file = File.open("#{Rails.root}/test/fixtures/files/log.pdf", 'r')
    art_gallery = ArtGallery.new(file, 'pdf')
    assert_not art_gallery.valid?
  end

  test "should be valid for text file" do
    file = File.open("#{Rails.root}/test/fixtures/files/log.text", 'r')
    art_gallery = ArtGallery.new(file, 'text/plain')
    assert art_gallery.valid?
  end

  test "should return an array with visit records" do
    response = [["0", 20, 2]]
    file = File.open("#{Rails.root}/test/fixtures/files/log.text", 'r')
    art_gallery = ArtGallery.new(file, 'text/plain')
    results = art_gallery.collect_data
    assert_equal response, results
  end

end
