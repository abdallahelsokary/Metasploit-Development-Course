require "msf/core"
require "nokogiri"
require "net/http"
require "net/https"
class MetasploitModule < Msf::Auxiliary
	include Msf::Auxiliary::Report
	Rank = GreatRanking
	def initialize(info = {})
		super(update_info(info,

				'Name' => 'html main parser',
				'Description' => %q{
					html main parser
				},
				'Author' => ['abdallah elsokary <abdallahelsokary@github.com>'],
				'License' => MSF_LICENSE,
				'Version' => '1.0'))
		register_options(
			[

				OptString.new('DOMAIN',[true,'domain for parsing']),
				OptString.new('REQUEST',[true,'request path']),
				OptString.new('FILE',[false,' file for saving data']),
				OptString.new('OPTION',[false,'data option']),
				OptString.new('XPATH',[true,'XPATH']),



			],self.class)
	end
	def run
	$site = datastore["DOMAIN"]
	$site_info  = URI.parse($site)
	$parse = Net::HTTP.new($site_info.host,$site_info.port)
	$parse.use_ssl = true
	$parse.verify_mode = OpenSSL::SSL::VERIFY_NONE
	$data = $parse.get(datastore["REQUEST"])
	$html = $data.body
	$parser = Nokogiri::HTML($html)
	$file = datastore["FILE"]
	if $file !=nil then
		$mkfile = File.new($file,"w")
	end
	$parser.xpath(datastore["XPATH"]).each do |d|
		$option = datastore['OPTION']
		if $option == nil then
			puts d
			if $file !=nil then
				$mkfile.write("#{d}\n")
			end
		else
			puts d[$option]
			if $file != nil then
				$mkfile.write("#{d[$option]}\n")
			end
		end
	end
	if $file != nil then
		puts "the file is saved as #{$file}"
	end
	end
end