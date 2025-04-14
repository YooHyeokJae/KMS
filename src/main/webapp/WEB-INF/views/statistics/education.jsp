<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<div class="container">
    <h2 style="border-bottom: 2px solid #333; display: inline-block; padding: 5px 12px; border-radius: 10px;">
        <span style="color: #003366"><i class="bi bi-bar-chart-line-fill"></i> 교육 통계</span>
    </h2>

    <div id="main">
        <p class="d-flex justify-content-end align-items-center position-relative" style="margin-bottom: -40px;">
            <label for="entryYearNum">
                <span>최근</span>
                <span>
                    <input type="number" id="entryYearNum" value="5" />
                </span>
                <span>년</span>
            </label>
            <input type="button" class="btn btn-outline-dark" id="entryRedraw" value="보기" />
        </p>
        <div class="graphBox">
            <canvas id="entryCanvas" width="600" height="210"></canvas>
        </div>
        <br>
        <br>
        <p class="d-flex justify-content-end align-items-center position-relative" style="margin-bottom: -40px;">
            <label for="teacherYearNum">
                <span>최근</span>
                <span>
                    <input type="number" id="teacherYearNum" value="5" />
                </span>
                <span>년</span>
            </label>
            <input type="button" class="btn btn-outline-dark" id="teacherRedraw" value="보기" />
        </p>
        <div class="graphBox">
            <canvas id="teacherCanvas" width="600" height="210"></canvas>
        </div>
        <br>
        <br>
        <div class="graphBox">
            <canvas id="studentCanvas" width="600" height="210"></canvas>
        </div>
    </div>

</div>

<script>
    let entryStats = [];
    let entryLabels;
    let entryData;
    let graduateData;

    let teacherStats = [];
    let teacherLabels;
    let teacherData;

    let studentStats = [];
    let studentLabels;
    let studentData;

    function getEntryData(){
        entryStats = [
            <c:forEach var="item" items="${entryStats}" varStatus="stat">
            {
                year: "${item.year}",
                entry: ${item.entryCnt},
                graduate: ${item.graduateCnt}
            }<c:if test="${!stat.last}">, </c:if>
            </c:forEach>
        ];
        entryLabels = entryStats.map(item => item.year);
        entryData = entryStats.map(item => item.entry);
        graduateData = entryStats.map(item => item.graduate);
    }

    function getTeacherData(){
        teacherStats = [
            <c:forEach var="item" items="${teacherStats}" varStatus="stat">
                {
                    year: "${item.year}",
                    teacher: ${item.teacherCnt}
                }<c:if test="${!stat.last}">, </c:if>
            </c:forEach>
        ];
        teacherLabels = teacherStats.map(item => item.year);
        teacherData = teacherStats.map(item => item.teacher);
    }

    function getStudentData(){
        studentStats = [
            <c:forEach var="item" items="${studentStats}" varStatus="stat">
            {
                grade: "${item.grade}",
                student: ${item.studentCnt}
            }<c:if test="${!stat.last}">, </c:if>
            </c:forEach>
        ];
        studentLabels = studentStats.map(item => item.grade);
        studentData = studentStats.map(item => item.student);
    }
</script>

<script>
    <%-- 입학/졸업생 수 --%>
    let entryCtx;
    let entryChart;
    function drawEntryChart(){
        entryCtx = document.getElementById('entryCanvas').getContext('2d');
        entryChart = new Chart(entryCtx, {
            type: 'line',
            data: {
                labels: entryLabels,
                datasets: [
                    {
                        label: '입학생',
                        data: entryData,
                        backgroundColor: 'rgba(135, 206, 235, 0.2)',
                        borderColor: 'rgba(135, 206, 235, 1)',
                        borderWidth: 1,
                        fill: true,
                        pointBackgroundColor: 'white',
                        pointBorderColor: 'rgba(135, 206, 235, 1)',
                        pointRadius: 5
                    },
                    {
                        label: '졸업생',
                        data: graduateData,
                        backgroundColor: 'rgba(128, 0, 32, 0.2)',
                        borderColor: 'rgba(128, 0, 32, 1)',
                        borderWidth: 1,
                        fill: true,
                        pointBackgroundColor: 'white',
                        pointBorderColor: 'rgba(128, 0, 32, 1)',
                        pointRadius: 5
                    }
                ]
            },
            options: {
                responsive: true,
                plugins: {
                    title: {
                        display: true,
                        text: '입학/졸업',
                        font: {
                            size: 18
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                return context.parsed.y + ' 명';
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 1
                        },
                        title: {
                            display: true,
                            text: '인원 (명)'
                        }
                    },
                    x: {
                        title: {
                            display: true,
                            text: '년'
                        }
                    }
                }
            }
        });
    }

    <%-- 재직 교사 수 --%>
    let teacherCtx;
    let teacherChart;
    function drawTeacherChart(){
        teacherCtx = document.getElementById('teacherCanvas').getContext('2d');
        teacherChart = new Chart(teacherCtx, {
            type: 'bar',
            data: {
                labels: teacherLabels,
                datasets: [
                    {
                        label: '교사',
                        data: teacherData,
                        backgroundColor: 'rgba(74, 144, 226, 0.2)',
                        borderColor: 'rgba(74, 144, 226, 1)',
                        borderWidth: 1
                    }
                ]
            },
            options: {
                responsive: true,
                plugins: {
                    title: {
                        display: true,
                        text: '년도별 재직 교사 수',
                        font: {
                            size: 18
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                return context.parsed.y + ' 명';
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 1
                        },
                        title: {
                            display: true,
                            text: '인원 (명)'
                        }
                    },
                    x: {
                        title: {
                            display: true,
                            text: '년'
                        }
                    }
                }
            }
        });
    }

    <%-- 반별 원생 수 --%>
    let studentCtx;
    let studentChart;
    function drawStudentChart(){
        studentCtx = document.getElementById('studentCanvas').getContext('2d');
        studentChart = new Chart(studentCtx, {
            type: 'bar',
            data: {
                labels: studentLabels,
                datasets: [
                    {
                        label: '원생',
                        data: studentData,
                        backgroundColor: 'rgba(245, 166, 35, 0.2)',
                        borderColor: 'rgba(245, 166, 35, 1)',
                        borderWidth: 1
                    }
                ]
            },
            options: {
                responsive: true,
                plugins: {
                    title: {
                        display: true,
                        text: '학급별 원생 수',
                        font: {
                            size: 18
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                return context.parsed.y + ' 명';
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 1
                        },
                        title: {
                            display: true,
                            text: '인원 (명)'
                        }
                    },
                    x: {
                        title: {
                            display: true,
                            text: '학급'
                        }
                    }
                }
            }
        });
    }
</script>

<script>
    getEntryData();
    drawEntryChart();
    getTeacherData();
    drawTeacherChart();
    getStudentData();
    drawStudentChart();

    $('input[type="number"]').on('change', function(){
        if($(this).val() < 1){
            $(this).val('1');
        }
        if($(this).val() > 30){
            $(this).val('30');
        }
    });

    $('#entryRedraw').on('click', function(){
        if (entryChart) {
            entryChart.destroy();
        }

        let data = {
            chart: 'entry',
            year: $('#entryYearNum').val()
        }

        $.ajax({
            url: '/statistics/redrawChart',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function(result){
                entryStats = result;
                entryLabels = entryStats.map(item => item.year);
                entryData = entryStats.map(item => item.entryCnt);
                graduateData = entryStats.map(item => item.graduateCnt);
                drawEntryChart();
            }
        });
    });

    $('#teacherRedraw').on('click', function(){
        if(teacherChart) {
            teacherChart.destroy();
        }

        let data = {
            chart: 'teacher',
            year: $('#teacherYearNum').val()
        }

        $.ajax({
            url: '/statistics/redrawChart',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function(result){
                teacherStats = result;
                teacherLabels = teacherStats.map(item => item.year);
                teacherData = teacherStats.map(item => item.teacherCnt);
                drawTeacherChart();
            }
        });
    })
</script>