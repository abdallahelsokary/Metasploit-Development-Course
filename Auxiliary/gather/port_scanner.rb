require "msf/core"
require "nmap/program"
class MetasploitModule < Msf::Auxiliary
	include Msf::Auxiliary::Report
	include Msf::Auxiliary::Scanner
	Rank = GreatRanking
	def initialize(info = {})
		super(update_info(info,

				'Name' => 'Port scanner',
				'Description' => %q{
					port scanner auxiliary
				},
				'Author' => ['abdallah elsokary <abdallahelsokary@github.com>'],
				'License' => MSF_LICENSE,
				'Version' => '1.0'))
		register_options(
			[

				#OptString.new('TARGETS',[true,'targets ips']),
				OptString.new('PORTS',[true,'ports for scan']),
				OptString.new('XMLFILE',[true,'xml file for saving']),


			],self.class)
	end
	def run
		$targets = datastore['RHOSTS']
		$ports = datastore['PORTS']
		$xmlfile = datastore['XMLFILE']
		print_status("starting scan")
		Nmap::Program.scan do |nmap|
			nmap.syn_scan = true
			nmap.service_scan = true
			nmap.os_fingerprint = true
			nmap.xml = $xmlfile
			nmap.ports = [$ports]
			nmap.targets = $targets
		end
	end
end