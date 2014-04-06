function getJobs() {
  $.getJSON(
    '/jobs',
    '',
    function(jobs) {
      $('#failedJobsTable tbody').empty();
      $('#runningJobsTable tbody').empty();
      $('#completedJobsTable tbody').empty();

      $.each(jobs, function(key, job) {
        var items = [];
        items.push("<tr>");
        items.push("<td>" + job.jobId + "</td>");
        items.push("<td>" + job.classPath + "</td>");
        items.push("<td>" + job.context + "</td>");
        items.push("<td>" + job.startTime + "</td>");
        items.push("<td>" + job.duration + "</td>");
        items.push("</tr>");

        if(job.status == 'ERROR') {
          $('#failedJobsTable > tbody:last').append(items.join(""));
        } else if(job.status == 'RUNNING') {
          $('#runningJobsTable > tbody:last').append(items.join(""));
        } else {
          $('#completedJobsTable > tbody:last').append(items.join(""));
        }
      });
    });
}

function getContexts() {
  $.getJSON(
    '/contexts',
    '',
    function(contexts) {
      $('#contextsTable tbody').empty();

      $.each(contexts, function(key, contextName) {
        var items = [];
        items.push("<tr><td>" + contextName + "</td></tr>");
        $('#contextsTable > tbody:last').append(items.join(""));
      });
    });
}

function getJars() {
  $.getJSON(
    '/jars',
    '',
    function(jars) {
      $('#jarsTable tbody').empty();

      $.each(jars, function(jarName, deploymentTime) {
        var items = [];
        items.push("<tr>");
        items.push("<td>" + jarName + "</td>");
        items.push("<td>" + deploymentTime + "</td>");
        items.push("</tr>");
        $('#jarsTable > tbody:last').append(items.join(""));
      });
    });
}

// TODO: not working?
$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
  var target = $(e.target).attr("href") // activated tab
  if ($(target).is(':empty')) {
    alert(target);
  }
});

$(document).ready(getJobs());
$(document).ready(getContexts());
$(document).ready(getJars());

$(document).ajaxError(function (e, xhr, settings, exception) {
            alert('error in: ' + settings.url + ' \\n' + 'error:\\n' + exception);});