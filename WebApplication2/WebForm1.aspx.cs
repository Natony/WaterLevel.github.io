using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindGridView();
            }
            DataTable dt = new DataTable();
            dt = GetTankData();
            //for Chart X axis value
            var waterleveldate = dt.AsEnumerable().Select(s => s.Field<DateTime>("WaterLevelDate").ToLongDateString()).Distinct().ToArray();
            chartlabelvalue.Value = string.Join(",", waterleveldate);

            //Tank 1 Value
            var tank1 = dt.AsEnumerable().Where(m => m.Field<string>("TankName") == "Tank1").Select(s => s.Field<decimal>("WaterLevelValue")).ToArray();
            charttank1.Value = string.Join(",", tank1);

            //Tank 2 Value
            var tank2 = dt.AsEnumerable().Where(m => m.Field<string>("TankName") == "Tank2").Select(s => s.Field<decimal>("WaterLevelValue")).ToArray();
            charttank2.Value = string.Join(",", tank2);

            // Bind data to the table display
            gvdata.DataSource = dt;
            gvdata.DataBind();

            chart1value.Value = Convert.ToString(dt.AsEnumerable().Where(m => m.Field<string>("TankName") == "Tank1").OrderByDescending(m => m.Field<int>("Id")).Select(s => s.Field<decimal>("WaterLevelValue")).ToArray()[0] / 300);
            chart2value.Value = Convert.ToString(dt.AsEnumerable().Where(m => m.Field<string>("TankName") == "Tank2").OrderByDescending(m => m.Field<int>("Id")).Select(s => s.Field<decimal>("WaterLevelValue")).ToArray()[0] / 300);
        }

        private void BindGridView()
        {
            DataTable dt = GetTankData();

            // Sort the DataTable based on the selected sort order
            string sortOrder = ddlSort.SelectedValue;
            if (sortOrder == "ASC")
            {
                dt.DefaultView.Sort = "WaterLevelDate ASC";
            }
            else if (sortOrder == "DESC")
            {
                dt.DefaultView.Sort = "WaterLevelDate DESC";
            }

            gvdata.DataSource = dt;
            gvdata.DataBind();
        }

        protected void gvdata_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvdata.PageIndex = e.NewPageIndex;
            BindGridView(); // Rebind the GridView with data for the new page
        }

        protected void ddlSort_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Handle the sorting logic here
            BindGridView();
        }

        public DataTable GetTankData()
        {
            DataTable dt = new DataTable();
            SqlConnection con = new SqlConnection(@"Server=LAPTOP-DCEG33FN\SQLSEVER2022; Database=WaterTank; Integrated Security=True;");
            try
            {
                SqlDataAdapter da = new SqlDataAdapter("Select * from WaterLevel;", con);
                con.Open();
                da.Fill(dt);
            }
            catch
            {
                // Handle any exceptions
            }
            finally
            {
                con.Close();
            }
            return dt;
        }
    }
}