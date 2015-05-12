class TheCorsair extends ZeroFrame

	# Wrapper websocket connection ready
	onOpenWebsocket: (e) =>
		@cmd "serverInfo", {}, (serverInfo) =>
			@log "mysite serverInfo response", serverInfo
		@cmd "siteInfo", {}, (siteInfo) =>
			@log "mysite siteInfo response", siteInfo

	torrentCount: =>
		@cmd "dbQuery", ["SELECT count(*) as kct FROM torrent"], (res) =>
			$(".kat-count").text(res[0]["kct"] + " ebook torrents")

	listTorrents: (startOfDay=moment().startOf('day').format("X")) ->
		@template = $(".torrent-row.template").clone()

		endOfDay = moment(startOfDay,"X").endOf('day').format("X")
		yesterday = moment(startOfDay,'X').subtract(1,'days').format('X')
		tomorrow = moment(startOfDay,'X').add(1,'days').format('X')

		$(".loading").show()
		$(".page-control").hide()
		$(".torrents").html("")
		@log $("#btn-next")
		if moment().startOf('day').format("X") != startOfDay
			$("#btn-next").attr("onclick", "torrents.listTorrents('#{tomorrow}')").show()
			$(".next-label").text(moment(tomorrow,"X").format("D/MM/YYYY"))
		else
			$("#btn-next").hide()

		$("#btn-prev").attr("onclick", "torrents.listTorrents('#{yesterday}')").show()
		$(".prev-label").text(moment(yesterday,"X").format("D/MM/YYYY"))


		$(".today-label").html(moment(startOfDay,"X").format("D/MM/YYYY"))


		@cmd "dbQuery", ["SELECT * FROM torrent WHERE upload_date <= #{endOfDay} AND upload_date >= #{startOfDay}"], (res) =>

			$(".torrents-count").text(res.length + " torrents")
			if res.error or res.length == 0
				$(".torrents").html($("#noResultsDay").clone().show())
				$(".loading").hide()
				$(".page-control").show()
				return


			for torrent in res
				@addTorrentToList(torrent)
			$(".loading").hide()
			$(".page-control").show()

		

	addTorrentToList: (torrent, search=0) =>
		elem = @template.clone().removeClass("template")
		$(".name", elem).text(torrent.name)
		$(".category", elem).text(torrent.category)
		$(".origin", elem).text(torrent.origin)
		$(".date", elem).text(@formatSince(torrent.upload_date))
		$(".size", elem).text(bytesToSize(torrent.size))
		if search
			$(".date", elem).show()
		else
			$(".date", elem).hide()
		$(".torrent_download_url", elem).attr("href", torrent.download_url)
		magnet_url = "magnet:?xt=urn:btih:#{torrent.hash}&dn=#{torrent.name.replace(/[^a-z0-9]/gi, '_').toLowerCase();}&tr=udp%3A%2F%2Ftracker.publicbt.com%3A80&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A80&tr=udp%3A%2F%2Ftracker.ccc.de%3A80&tr=udp%3A%2F%2Ftracker.istole.it%3A80"
		$(".magnet_download_url", elem).attr("href", magnet_url)
		elem.appendTo($(".torrents"))
		#$("table.torrents tr:last").after(elem)

	makeSearch: (string) =>
		$(".loading").show()
		$(".page-control").hide()

		@template = $(".torrent-row.template").clone()
		if string == ""
			@listTorrents()
			return

		$(".today-label").html("Results for '#{string}'")

		$("#btn-prev").hide()
		$("#btn-next").hide()

		$(".torrents").html("")

		@cmd "dbQuery", ["SELECT * FROM torrent WHERE name LIKE '#{string}' ORDER BY upload_date DESC"], (res) =>
			$(".torrents-count").text(res.length + " torrents")

			if res.error or res.length == 0
				$(".torrents").html($("#noResultsSearch").clone().show())
				$(".loading").hide()
				$(".page-control").show()
				return

			for torrent in res
				@addTorrentToList(torrent,1)
			$(".loading").hide()
			$(".page-control").show()



	# Format time since
	formatSince: (time) ->
		now = +(new Date)/1000
		secs = now - time
		if secs < 60
			return "Just now"
		else if secs < 60*60
			return "#{Math.round(secs/60)} minutes ago"
		else if secs < 60*60*24
			return "#{Math.round(secs/60/60)} hours ago"
		else
			return "#{Math.round(secs/60/60/24)} days ago"

window.torrents = new TheCorsair()