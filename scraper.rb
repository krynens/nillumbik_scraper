require 'scraperwiki'
require 'mechanize'

FileUtils.touch('data.sqlite')

today = Time.now.strftime('%Y-%m-%d')

url   = 'https://epathway.nillumbik.vic.gov.au/ePathway/Production/Web/GeneralEnquiry/ExternalRequestBroker.aspx?Module=EGELAP&Class=P1&Type=ADVERT'
agent = Mechanize.new
page  = agent.get(url)

table = page.search('table.ContentPanel')
rows = table.search('tr.ContentPanel', 'tr.AlternateContentPanel')

for row in rows do
  record = {}
  record['address'] = row.search('td')[2].text.strip
  record['council_reference'] = row.search('a').text.strip
  record['date_received'] = DateTime.strptime(row.search('td')[1].text.strip,'%d/%m/%Y').strftime('%Y-%m-%d')
  record['date_scraped'] = today
  record['description'] = row.search('td')[3].text.strip
  record['info_url'] = 'https://epathway.nillumbik.vic.gov.au/ePathway/Production/Web/GeneralEnquiry/' + row.search('a').to_s.split('"')[3]
  ScraperWiki.save_sqlite(['council_reference'], record)
end
