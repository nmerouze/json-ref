require "helper"

class TestJSONRef < MiniTest::Unit::TestCase
  def test_hash
    origin_doc = { "title" => { "value" => "foobar" }, "ref_title" => { "$ref" => "#/title" } }
    result_doc = { "title" => { "value" => "foobar" }, "ref_title" => { "value" => "foobar" } }

    assert_equal result_doc, JSONRef.new(origin_doc).expand
  end

  def test_nested_hash
    origin_doc = { "nested" => { "value" => "foobar" }, "ref_title" => { "$ref" => "#/nested" } }
    result_doc = { "nested" => { "value" => "foobar" }, "ref_title" => { "value" => "foobar" } }

    assert_equal result_doc, JSONRef.new(origin_doc).expand
  end

  def test_file_path
    origin_doc = { "file" => { "$ref" => "test/fixtures/file.json" } }
    result_doc = { "file" => { "title" => "My PDF", "path" => "/path/to/my.pdf" } }

    assert_equal result_doc, JSONRef.new(origin_doc).expand
  end

  def test_nested_ref
    origin_doc = { "title" => { "value" => "foobar" }, "file" => { "ref_title" => { "$ref" => "#/title" } } }
    result_doc = { "title" => { "value" => "foobar" }, "file" => { "ref_title" => { "value" => "foobar" } } }

    assert_equal result_doc, JSONRef.new(origin_doc).expand
  end

  def test_multiple_ref
    origin_doc = { "title" => { "value" => "foobar" }, "file" => { "ref_title" => { "$ref" => "#/title" } }, "post" => { "ref_title" => { "$ref" => "#/title" } } }
    result_doc = { "title" => { "value" => "foobar" }, "file" => { "ref_title" => { "value" => "foobar" } }, "post" => { "ref_title" => { "value" => "foobar" } } }

    assert_equal result_doc, JSONRef.new(origin_doc).expand
  end

  def test_ref_in_array
    origin_doc = { "title" => [{ "value" => "foobar" }], "ref_title" => { "$ref" => "#/title" } }
    result_doc = { "title" => [{ "value" => "foobar" }], "ref_title" => [{ "value" => "foobar" }] }

    assert_equal result_doc, JSONRef.new(origin_doc).expand
  end
end