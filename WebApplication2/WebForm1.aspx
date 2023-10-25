<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="WebApplication2.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="Js/echarts.js"></script>
    <script src="Js/echarts-liquidfill.js"></script>
    <link href="css/chart.css" rel="stylesheet" />

    <script src="https://www.chartjs.org/dist/2.9.3/Chart.min.js"></script>
    <script src="https://www.chartjs.org/samples/latest/utils.js"></script>
    <style>
        .dashboardarea {
            width: 48%;
            border-right: 0px solid #808080;
            margin-right: 0;
            float: left;
        }

        #chart1, #chart2, #label1, #label2 {
            width: 48%;
            margin-right: 10px;
            float: left;
            text-align: center;
        }
    </style>
    <style>
        table {
            font-family: arial, sans-serif;
            border-collapse: collapse;
            width: 100%;
        }

        td, th {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }

        th {
            background-color: #1d4aa8;
            color: white;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div style="width: 100%; background-color: #808080; height: 20px;"></div>
        <div class="dashboardarea">
            <div class="chart" id="chart1"></div>
            <div class="chart" id="chart2"></div>
            <div id="label1"><b>Tank 1</b></div>
            <div id="label2"><b>Tank 2</b></div>
            <asp:HiddenField ID="chart1value" runat="server" />
            <asp:HiddenField ID="chart2value" runat="server" />
        </div>
        <div class="dashboardarea">
            <asp:DropDownList ID="ddlSort" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlSort_SelectedIndexChanged">
                <asp:ListItem Text="Sắp xếp theo thời gian tăng dần" Value="ASC"></asp:ListItem>
                <asp:ListItem Text="Sắp xếp theo thời gian giảm dần" Value="DESC"></asp:ListItem>
            </asp:DropDownList>
            <br />
            <asp:GridView ID="gvdata" runat="server" AllowPaging="True" PageSize="5" OnPageIndexChanging="gvdata_PageIndexChanging">
            </asp:GridView>
        </div>
        <div class="dashboardarea" style="width: 100%">
            <hr />
        </div>
        <div class="dashboardarea" style="width: 100%; height: 50%;">
            <div style="width: 100%; height: 100px;">
                <canvas id="canvas" style="height: 33vh; width: 80vw"></canvas>
                <asp:HiddenField ID="chartlabelvalue" runat="server" />
                <asp:HiddenField ID="charttank1" runat="server" />
                <asp:HiddenField ID="charttank2" runat="server" />
            </div>
        </div>
        <script>
            var val1 = document.getElementById("<%=chart1value.ClientID %>").value;
            var val2 = document.getElementById("<%=chart2value.ClientID %>").value;
            var containers = document.getElementsByClassName('chart');
            var options = [{
                series: [{
                    type: 'liquidFill',
                    data: [val1],
                    radius: '55%',

                }]
            }, {
                series: [{
                    type: 'liquidFill',
                    data: [val2],
                    radius: '55%',
                }]
            }];

            var charts = [];
            for (var i = 0; i < options.length; ++i) {
                var chart = echarts.init(containers[i]);

                if (i > 0) {
                    options[i].series[0].silent = true;
                }
                chart.setOption(options[i]);
                chart.setOption({
                    baseOption: options[i],
                    media: [{
                        query: {
                            maxWidth: 100
                        },
                        option: {
                            series: [{
                                label: {
                                    fontSize: 26
                                }
                            }]
                        }
                    }]
                });

                charts.push(chart);
            }

            window.onresize = function () {
                for (var i = 0; i < charts.length; ++i) {
                    charts[i].resize();
                }
            };

            //Display chart

            // Wait for the document to be ready
            document.addEventListener("DOMContentLoaded", function () {
                // Retrieve data from hidden fields
                var tankvallavel
                // Retrieve data from hidden fields
                var tankvallavel = document.getElementById("<%=chartlabelvalue.ClientID %>").value.split(',');
                var tank1data = document.getElementById("<%=charttank1.ClientID %>").value.split(',').map(parseFloat);
                var tank2data = document.getElementById("<%=charttank2.ClientID %>").value.split(',').map(parseFloat);

                // Define the chart data
                var chartData = {
                    labels: tankvallavel,
                    datasets: [
                        {
                            label: 'Tank 1',
                            borderColor: 'red',
                            data: tank1data,
                            fill: false
                        },
                        {
                            label: 'Tank 2',
                            borderColor: 'blue',
                            data: tank2data,
                            fill: false
                        }
                    ]
                };

                // Define chart options
                var chartOptions = {
                    responsive: true,
                    title: {
                        display: true,
                        text: 'Water Level Status'
                    },
                    scales: {
                        xAxes: [{
                            display: true,
                            scaleLabel: {
                                display: true,
                                labelString: 'Date'
                            }
                        }],
                        yAxes: [{
                            display: true,
                            scaleLabel: {
                                display: true,
                                labelString: 'Value'
                            }
                        }]
                    }
                };

                // Create a chart
                var ctx = document.getElementById('canvas').getContext('2d');
                var myChart = new Chart(ctx, {
                    type: 'line',
                    data: chartData,
                    options: chartOptions
                });
            });

            window.onload = function () {
                var ctx = document.getElementById('canvas').getContext('2d');
                window.myLine = new Chart(ctx, config);
            };
        </script>
    </form>
</body>
</html>