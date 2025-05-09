<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0/dist/chartjs-plugin-datalabels.min.js"></script>

<div class="container">
    <h2 style="border-bottom: 2px solid #333; display: inline-block; padding: 5px 12px; border-radius: 10px;">
        <span style="color: #3B82F6"><i class="bi bi-bar-chart-line"></i> 접속 통계</span>
    </h2>
    <div class="graphBox mb-3" style="min-height: 460px;">
        <div class="d-flex align-items-center justify-content-end position-relative" style="margin-bottom: -40px;">
            <label for="strDate"></label><input type="date" id="strDate" class="form-control" value="${strDate}" style="width: 10%;" />
            <span class="ms-3 me-3">~</span>
            <label for="endDate"></label><input type="date" id="endDate" class="form-control" value="${endDate}" style="width: 10%;"/>
            <input type="button" class="btn btn-light ms-3" id="searchLoginStats" value="검색" />
        </div>
        <canvas id="loginCanvas" width="600" height="210"></canvas>
    </div>
    <div class="graphBox mt-3 mb-3 d-flex justify-content-between" style="width: 50%; height: 460px;">
        <canvas id="userCanvas" style="width: 300px; height: 300px;"></canvas>
        <canvas id="pageCanvas" style="width: 300px; height: 300px;"></canvas>
    </div>
</div>

<script>
    let userStats = [];
    let userLabels;
    let userData;
    function getUserStatsData(){
        userStats = [
            <c:forEach var="item" items="${statsByUser}" varStatus="stat">
            {
                gubun: "${item.gubun}",
                cnt: ${item.cnt},
            }<c:if test="${!stat.last}">, </c:if>
            </c:forEach>
        ];
        userLabels = userStats.map(item => item.gubun);
        userData = userStats.map(item => item.cnt);
    }

    let pageStats = [];
    let pageLabels;
    let pageData;
    function getPageStatsData(){
        pageStats = [
            <c:forEach var="item" items="${statsByPageUrl}" varStatus="stat">
            {
                gubun: "${item.gubun}",
                cnt: ${item.cnt},
            }<c:if test="${!stat.last}">, </c:if>
            </c:forEach>
        ];
        pageLabels = pageStats.map(item => item.gubun);
        pageData = pageStats.map(item => item.cnt);
    }

    let loginStats = [];
    let loginLabels;
    let loginData;
    function getLoginStatsData(){
        loginStats = [
            <c:forEach var="item" items="${statsByLogin}" varStatus="stat">
            {
                gubun: "${item.gubun}",
                cnt: ${item.cnt},
            }<c:if test="${!stat.last}">, </c:if>
            </c:forEach>
        ];
        loginLabels = loginStats.map(item => item.gubun);
        loginData = loginStats.map(item => item.cnt);
    }

    function randomColor(){
        let r = Math.floor(Math.random() * 256);
        let g = Math.floor(Math.random() * 256);
        let b = Math.floor(Math.random() * 256);
        let a = 0.2;
        return 'rgba(' + r + ', ' + g + ', ' + b + ', ' + a + ')';
    }

    Chart.register(ChartDataLabels); // 전역 등록

    let userCtx;
    let userChart;
    function drawUserChart(){
        userCtx = document.getElementById('userCanvas').getContext('2d');
        userChart = new Chart(userCtx, {
            type: 'pie',
            data: {
                labels: userLabels,
                datasets: [
                    {
                        data: userData,
                        backgroundColor: ['rgba(0, 123, 255, 0.2)', 'rgba(253, 126, 20, 0.2)', 'rgba(111, 66, 193, 0.2)', 'rgba(40, 167, 69, 0.2)', 'rgba(169, 169, 169, 0.2)'],
                        borderColor: ['rgba(0, 123, 255, 1)', 'rgba(253, 126, 20, 1)', 'rgba(111, 66, 193, 1)', 'rgba(40, 167, 69, 1)', 'rgba(169, 169, 169, 1)'],
                        borderWidth: 1
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'left',
                        labels: {
                            boxWidth: 20,
                            padding: 15,
                            font: {
                                size: 14
                            }
                        }
                    },
                    title: {
                        display: true,
                        text: '유저 비율',
                        font: {
                            size: 18
                        }
                    },
                    datalabels: {
                        color: '#000',
                        font: {
                            weight: 'bold',
                            size: 14
                        },
                        formatter: (value, context) => {
                            return value + '명';
                        },
                        align: 'start',      // end, start, center 등
                        anchor: 'end',     // where to anchor (center, start, end)
                    }
                }
            },
            plugins: [ChartDataLabels]
        });
    }

    let pageCtx;
    let pageChart;
    function drawPageChart(){
        const randomColors = pageLabels.map(() => randomColor());
        pageCtx = document.getElementById('pageCanvas').getContext('2d');
        pageChart = new Chart(pageCtx, {
            type: 'pie',
            data: {
                labels: pageLabels,
                datasets: [
                    {
                        data: pageData,
                        backgroundColor: randomColors,
                        borderColor: randomColors,
                        borderWidth: 1
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'right',
                        labels: {
                            boxWidth: 20,
                            padding: 15,
                            font: {
                                size: 14
                            }
                        }
                    },
                    title: {
                        display: true,
                        text: '페이지별 접속자 수',
                        font: {
                            size: 18
                        }
                    },
                    datalabels: {
                        color: '#000',
                        font: {
                            weight: 'bold',
                            size: 14
                        },
                        formatter: (value, context) => {
                            return value + '명';
                        },
                        align: 'start',      // end, start, center 등
                        anchor: 'end',     // where to anchor (center, start, end)
                    }
                }
            },
            plugins: [ChartDataLabels]
        });
    }

    let loginCtx;
    let loginChart;
    function drawLoginChart(){
        loginCtx = document.getElementById('loginCanvas').getContext('2d');
        loginChart = new Chart(loginCtx, {
            type: 'line',
            data: {
                labels: loginLabels,
                datasets: [
                    {
                        label: '접속자',
                        data: loginData,
                        backgroundColor: 'rgba(135, 206, 235, 0.2)',
                        borderColor: 'rgba(135, 206, 235, 1)',
                        borderWidth: 1,
                        fill: true,
                        pointBackgroundColor: 'white',
                        pointBorderColor: 'rgba(135, 206, 235, 1)',
                        pointRadius: 5
                    }
                ]
            },
            options: {
                responsive: true,
                plugins: {
                    title: {
                        display: true,
                        text: '일별 접속자 수',
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
                            text: '수 (명)'
                        }
                    },
                    x: {
                        title: {
                            display: true,
                            text: '일'
                        }
                    }
                }
            }
        });
    }
</script>

<script>
    $(document).ready(function(){
        getUserStatsData();
        getPageStatsData();
        getLoginStatsData();
        drawUserChart();
        drawPageChart();
        drawLoginChart();
    });

    $('#searchLoginStats').on('click', function(){
        let data = {
            strDate: $('#strDate').val(),
            endDate: $('#endDate').val(),
        }

        $.ajax({
            url: '/statistics/searchLoginStats',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function(result){
                loginStats = result.map(item => ({
                    gubun: item.gubun,
                    cnt: item.cnt
                }));
                loginLabels = loginStats.map(item => item.gubun);
                loginData = loginStats.map(item => item.cnt);

                if (loginChart) {
                    loginChart.destroy();
                }
                drawLoginChart();
            }
        });
    });
</script>
