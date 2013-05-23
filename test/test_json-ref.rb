require 'helper'

class TestJSONRef < MiniTest::Unit::TestCase
  def test_expand_string
    origin_doc = { 'title' => 'foobar', 'ref_title' => { '$ref' => '#/title' } }
    result_doc = { 'title' => 'foobar', 'ref_title' => 'foobar' }

    assert_equal result_doc, JSONRef.new(origin_doc).expand
  end

  def test_expand_hash
    origin_doc = { 'title' => { 'value' => 'foobar' }, 'ref_title' => { '$ref' => '#/title' } }
    result_doc = { 'title' => { 'value' => 'foobar' }, 'ref_title' => { 'value' => 'foobar' } }

    assert_equal result_doc, JSONRef.new(origin_doc).expand
  end

  def test_expand_complex_path
    origin_doc = { 'nested' => { 'title' => 'foobar' }, 'ref_title' => { '$ref' => '#/nested/title' } }
    result_doc = { 'nested' => { 'title' => 'foobar' }, 'ref_title' => 'foobar' }

    assert_equal result_doc, JSONRef.new(origin_doc).expand
  end
end