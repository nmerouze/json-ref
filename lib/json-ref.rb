require "json"
require "hana"
require 'json_ref/version'

class JSONRef
  def initialize(document)
    @document = document
    @refs = []
    @patches = []
  end

  def expand
    find_refs(@document).each do |path|
      ref = Hana::Pointer.eval(path, @document)['$ref']
      value = block_given? ?  yield(path, ref) : resolve_ref(path, ref)

      @patches << { "op" => "replace", "path" => path.unshift("").join("/"), "value" => value }
    end

    Hana::Patch.new(@patches).apply(@document)
  end

  def self.expand(document)
    self.new(document).expand
  end

  private

  def resolve_ref(path, ref)
    if ref =~ /\.json$/
      JSON.load(File.read(ref))
    else
      Hana::Pointer.new(ref[1..-1]).eval(@document)
    end
  end

  def find_refs(doc, path = [])
    if doc.has_key?("$ref")
      @refs << path
    else
      doc.each do |key, value|
        value.each_with_index do |item, index|
          find_refs(item, path + [key, index.to_s]) if item.is_a?(Hash)
        end if value.is_a?(Array)

        find_refs(value, path + [key]) if value.is_a?(Hash)
      end
    end

    @refs
  end
end
