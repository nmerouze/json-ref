require "json"
require "hana"

class JSONRef
  VERSION = "0.2.1"
  
  def initialize(document)
    @document = document
    @refs = []
    @patches = []
  end

  def expand
    find_refs(@document).each do |path|
      ref = Hana::Pointer.eval(path, @document)

      if ref["$ref"] =~ /\.json$/
        value = JSON.load(File.read(ref["$ref"]))
      else
        value = Hana::Pointer.new(ref["$ref"][1..-1]).eval(@document)
      end

      @patches << { "op" => "replace", "path" => path.unshift("").join("/"), "value" => value }
    end

    Hana::Patch.new(@patches).apply(@document)
  end

  def self.expand(document)
    self.new(document).expand
  end

  private

  def find_refs(doc, path = [])
    if doc.keys.include?("$ref")
      @refs << path
    else
      doc.each do |key, value|
        find_refs(value, path + [key]) if value.is_a?(Hash)
      end
    end

    @refs
  end
end