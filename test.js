ajax({ url: 'https://gdata.youtube.com/feeds/api/users/judo/live/events?v=2&status=active&inline=true' }, function(data){
  var active = data.match(/<yt:status>active<\/yt:status>/);
  simply.title(active);
});
