require "json"

class JSONRef
  VERSION = "0.2.0"
  
  def initialize(document)
    @document = document
    @refs = []
  end

  def expand
    find_refs(@document).each do |path|
      ref = path.inject(@document) { |doc, part| doc[part] }

      if ref["$ref"] =~ /\.json$/
        ref.replace read_file(ref["$ref"])
      else
        ref.replace split_path(ref["$ref"]).inject(@document) { |doc, part| doc[part] } # doesn't work for strings
      end
    end

    @document
  end

  def self.expand(document)
    self.new(document).expand
  end

  private

  def split_path(path)
    escape_characters = {"^/" => "/", "^^" => "^", "~0" => "~", "~1" => "/"}
    return [""] if path == "#/"

    path.sub(/^#\//, "").split(/(?<!\^)\//).map! { |part|
      part.gsub!(/\^[\/^]|~[01]/) { |m| escape_characters[m] }; part
    }
  end

  def read_file(path)
    JSON.load(File.read(path))
  end

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