$(document).ready(
  $.getJSON(
    "/jobs",
    '', // 'callback=?',
    function(data) {
      $.each(data, function(key, json) {
        var items = [];
        items.push("<tr>");
        items.push("<td>" + json.jobId + "</td>");
        items.push("<td>" + json.classPath + "</td>");
        items.push("<td>" + json.context + "</td>");
        items.push("<td>" + json.startTime + "</td>");
        items.push("<td>" + json.duration + "</td>");
        items.push("<td>" + json.status + "</td>");
        items.push("</tr>");

        if(json.status == 'ERROR') {
          $('#failedJobsTable > tbody:last').append(items.join(""));
        } else if(json.status == 'RUNNING') {
          $('#runningJobsTable > tbody:last').append(items.join(""));
        } else {
          $('#completedJobsTable > tbody:last').append(items.join(""));
        }
      });
    })
);

$(document).ready(
  $.getJSON(
    "/contexts",
    '', // 'callback=?',
    function(data) {
      $.each(data, function(key, contextName) {
        var items = [];
        items.push("<tr><td>" + contextName + "</td></tr>");
        $('#contextsTable > tbody:last').append(items.join(""));
      });
    })
);

$(document).ready(
  $.getJSON(
    "/jars",
    '', // 'callback=?',
    function(data) {
      $.each(data, function(jarName, deploymentTime) {
        var items = [];
        items.push("<tr>");
        items.push("<td>" + jarName + "</td>");
        items.push("<td>" + deploymentTime + "</td>");
        items.push("</tr>");
        $('#jarsTable > tbody:last').append(items.join(""));
      });
    })
);

$(document).ajaxError(function (e, xhr, settings, exception) {
            alert('error in: ' + settings.url + ' \\n' + 'error:\\n' + exception);});