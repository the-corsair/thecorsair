function bytesToSize(bytes) {
    var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
    if (bytes == 0) return 'n/a';
    var i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
    if (i == 0) return bytes + ' ' + sizes[i];
    return (bytes / Math.pow(1024, i)).toFixed(1) + ' ' + sizes[i];
};


//Include the navbar
$("nav.navbar").load("navbar.html?wrapper=False");

function navbarLoaded() {

    //Submit on Enter
    $('#search input').keydown(function(e) {
        if (e.keyCode == 13) {
            $('#main-content').hide();
            $('#search-content').show();
            torrents.makeSearch($("#searchString").val());
            event.preventDefault();
        }
    }); 

    //Call search fn on search submit
    $("#search").submit(function( event ) {
        $('#main-content').hide();
        $('#search-content').show();
        torrents.makeSearch($("#searchString").val());
        event.preventDefault();
    });   
}

function loadPage(page) {
    $('#search-content').hide();
    switch(page) {
        case "about":
            $('#main-content').load('about.html?wrapper=False').show();
            break;
        case "contribute":
            $('#main-content').load('contribute.html?wrapper=False').show();
            break;
        case "requests":
            $('#main-content').load('requests.html?wrapper=False').show();
            break;
        case "donations":
            $('#main-content').load('contribute.html?wrapper=False#donations').show();
            break;
    }
}


//initialize tooltip
$('[data-toggle="tooltip"]').tooltip();
$("#noResultsDay").hide();
$("#noResultsSearch").hide();

