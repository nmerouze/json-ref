require "json"

class JSONRef
  VERSION = "0.2.0"
  
  def initialize(document)
    @document = document
  end

  def expand
    @document.each do |k,v|
      if v.is_a?(Hash) && v.has_key?("$ref")
        if v["$ref"] =~ /\.json$/
          @document[k] = read_file(v["$ref"])
        else
          @document[k] = split_path(v["$ref"]).inject(@document) { |doc, item| doc[item] }
        end
      end
    end
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
end