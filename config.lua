cfg = {}


-- The event that initializes your framework. (set useFramework to false if standalone)
cfg.useFramework = true
cfg.frameworkInit = 'esx:init'

-- Requirements to receive a reward for uploading a video (/yt command)
cfg.requirements = {

    subs = 20,
    video_title = "Example Title",
    video_desc = "Example Desc",
    duration = "PT13S" -- use /duration videoURL command to get the correct duration

}


-- 'pl' or 'en'
cfg.lang = 'pl'
cfg.locales = {

    ['pl'] = {

        nosubs = "Nie posiadasz wystarczajacej Ilosci Subskrypcji!",
        wrongtitle = "Tytul Filmu nie zgadza sie z Wymaganym!",
        wrongdesc = "Opis Filmu nie zgadza sie z Wymaganym!",
        wrongduration = "Film nie jest nasza Reklama!",
        status = "Ten Film nie jest publiczny!",
        used = "Ten Film zostal juz uzyty do odebrania Rangi Youtuber.",
        ytalready = "Odebrales juz Range Youtuber!",
        fetching = "Uzyskiwanie potrzebnych Danych...",
        success = "Pomyslnie odebrales Range Youtuber!",
        videoduration = "Dlugosc Filmu: ",
        deleted = "Usunieto wszystkie usuniete/niepubliczne Filmy z Bazy Danych.",
        menuTITLE = "# Youtube API #",
        menuELEMENT = "Instrukcje",
        menuELEMENT2 = "Odbierz Range YT",
        instructions = "Aby odebrac range Youtuber,\nmusisz wrzucic nasza reklame, \nktora wlasnie dla ciebie skopiowalismy. \nwejdz w przegladarke, wklej link i pobierz plik .mp4,\nnastepnie wrzuc go z okreslonymi Wymaganiami"

    },
    ['en'] = {

        nosubs = "Your channel does not have enough Subscribers!",
        wrongtitle = "Video Title doesnt match with the required one.",
        wrongdesc = "Video Description doesnt match with the required one.",
        wrongduration = "This Video is not the one we requested you to upload!",
        status = "This Video is private/unlisted. Please change it to public and try again.",
        used = "This Video has already been used to claim the Youtuber Rank.",
        ytalready = "You already have the YT Rank!",
        success = "Pomyslnie odebrales Range Youtuber!",
        videoduration = "Video Duration: ",
        deleted = "Deleted all deleted/unlisted Videos from the Database",
        menuTITLE = "# Youtube API #",
        menuELEMENT = "Instructions",
        menuELEMENT2 = "Redeem YT Rank",
        instructions = [[
            To claim the Youtuber rank,
            You have to upload our Video that we just copied into your clipboard.
            Go into your browser, paste the link and download the .mp4 like.
            Next, upload it on Youtube.
        ]]

    }

}