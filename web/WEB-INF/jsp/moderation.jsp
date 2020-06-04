<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Moderation</title>
        <jsp:include page="meta.jsp" />
        
        <link rel="stylesheet" type="text/css" href="https://www.jeasyui.com/easyui/themes/default/easyui.css">
        <link rel="stylesheet" type="text/css" href="https://www.jeasyui.com/easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="https://www.jeasyui.com/easyui/themes/color.css">
        
        <script type="text/javascript" src="https://www.jeasyui.com/easyui/jquery.easyui.min.js"></script>
    </head>
    <body>
        <jsp:include page="header.jsp" />
        <div class="d-flex justify-content-center">
            <span class="align-middle" style="margin-top: 50px; width: 1000px;">
                <ul class="nav nav-tabs" id="myTab" role="tablist">
                    <li class="nav-item" width="100%">
                      <a class="nav-link active" id="home-tab" data-toggle="tab" href="#users" role="tab" aria-controls="users" aria-selected="true" onclick="recSearch('Users')">Users</a>
                    </li>
                    <li class="nav-item">
                      <a class="nav-link" id="profile-tab" data-toggle="tab" href="#points" role="tab" aria-controls="points" aria-selected="false" onclick="recSearch('Points')">Points</a>
                    </li>
                </ul>
                <div class="tab-content" id="myTabContent">
                    <div class="tab-pane fade show active border-right border-left border-bottom" style="height:500px" id="users" role="tabpanel" aria-labelledby="user-tab">
                        <table id="dgUsers" class="easyui-datagrid" style="height:500px;width:1000px" 
                               data-options="rownumbers:false,singleSelect:false,autoRowHeight:false,
                               toolbar:'#tbUsers',pageSize:100,url:'users/getList'">
                            <thead>
                                <tr>
                                    <th data-options="field:'username',align:'left',width:'250px',sortable:true"><center>Username</center></th>
                                    <th data-options="field:'name',align:'center',width:'250px',sortable:true"><center>Full Name</center></th>
                                    <th data-options="field:'email',align:'center',width:'250px',sortable:true"><center>E-mail</center></th>
                                    <th data-options="field:'confirmed',align:'center',width:'250px',sortable:true, formatter:formatConfirmed"><center>Confirmed</center></th>
                                </tr>
                            </thead>
                        </table>

                        <div id="tbUsers" style="padding:5px;height:auto">
                            <div style="margin-bottom:5px">
                                <a href="#" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="recDelete('Users')" style="width:40px" title="Delete"></a>
                                <span style="margin-left: 10px; margin-right: 10px;">Username: </span><input class="text" style="width:100px; height: 30px" id="usernameUsers" >
                                <button href="#" id="newUsers" class="btn btn-light border btn-sm" style="padding-bottom: 10px;margin-left: 20px;width:100px; height: 30px; margin-bottom: 3px" onclick="showNew()">Show New</button>
                                <button href="#" id="newUsers" class="btn btn-light border btn-sm" style="padding-bottom: 10px;margin-left: 20px;width:100px; height: 30px; margin-bottom: 3px" onclick="recConfirm()"><i class="fas fa-check"></i> Confirm</button>
                                <a href="#" class="easyui-linkbutton" iconCls="icon-search"  plain="true" style="float:right;width:40px" onclick="recSearch('Users')" title="Search"></a>
                            </div>
                        </div> 
                    </div>
                    
                    <div class="tab-pane fade border-right border-left border-bottom" id="points" style="height:500px" role="tabpanel" aria-labelledby="points-tab">
                        <table id="dgPoints" class="easyui-datagrid" style="height:500px;width:1000px" 
                               data-options="rownumbers:false,singleSelect:true,autoRowHeight:false,
                               toolbar:'#tbPoints',pageSize:100,url:'points/getList'">
                            <thead>
                                <tr>
                                    <th data-options="field:'name',align:'left',width:'250px',sortable:true"><center>Name</center></th>
                                    <th data-options="field:'address',align:'center',width:'250px',sortable:true"><center>Address</center></th>
                                    <th data-options="field:'user',align:'center',width:'250px',sortable:true,formatter:formatUsername"><center>Username</center></th>
                                    <th data-options="field:'type',align:'center',width:'250px',sortable:true,formatter:formatType"><center>Type</center></th>
                                </tr>
                            </thead>
                        </table>

                        <div id="tbPoints" style="padding:5px;height:auto">
                            <div style="margin-bottom:5px">
                                <a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="recNew()" style="width:40px" title="Add"></a>
                                <a href="#" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="recDelete('Points')" style="width:40px" title="Delete"></a>
                                <a href="#" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="recEdit()" style="width:40px" title="Edit"></a>
                                <span style="margin-right: 5px">Point name: </span><input class="text" style="width:100px; height: 30px" id="namePoints" >
                                <span style="margin-left: 10px; margin-right: 10px;">Username: </span><input class="text" style="width:100px; height: 30px" id="usernamePoints" >
                                <span style="margin-left: 10px; margin-right: 10px;">Address: </span><input class="text" style="width:100px; height: 30px" id="addressPoints" >
                                <span style="margin-left: 10px; margin-right: 10px;">Type: </span>
                                <select style="width:100px; height: 30px" id="type" onchange="recSearch('Points')">
                                    <option value="0">All</option>
                                    <option value="1">Waste recycling</option>
                                    <option value="2">Bicycle rental</option>
                                    <option value="3">Eco cafe</option>
                                </select>
                                <a href="#" class="easyui-linkbutton" iconCls="icon-search"  plain="true" style="float:right;width:40px" onclick="recSearch('Points')" title="Search"></a>
                            </div>
                        </div> 
                    </div>
                </div>
            </span>          
        </div>
        
         <!-- Modal -->
        <div class="modal fade" id="delModal" role="dialog">
          <div class="modal-dialog modal-dialog-centered">

            <!-- Modal content-->
            <div class="modal-content">
              <div class="modal-header">
                <h4 class="modal-title">Delete record</h4>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
              </div>
              <div class="modal-body">
                <p id="modalText">Some text in the modal.</p>
              </div>
              <div class="modal-footer">
                <button id="btnConfirm" type="button" class="btn btn-outline-success" data-dismiss="modal">Submit</button>
                <button type="button" class="btn btn-outline-secondary" data-dismiss="modal">Close</button>
              </div>
            </div>

          </div>
        </div>
    </body>
    
    <script>
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                recSearch('Users');
                recSearch('Points');
            }
        });
        
        $('#dgPoints').datagrid({ onDblClickCell: function(index,field,value){ recEdit(); }});
        
        $(document).ready(function() {
            recSearch('Users');
            recSearch('Points');
        });
        
        function recNew() {
            window.location.href = "points/edit";
        }

        function recEdit() {
            var id = $('#dgPoints').datagrid('getSelected').id;

            if (id > 0) {
                window.location.href = "points/edit?id=" + id;
            } else {
                alert("No selected records!");
            }
        }

        function recDelete(type) {
            var row = $('#dg' + type).datagrid('getSelected');

            if (row) {
                $('#modalText').text("Delete " + row.name + "?");
                $('#btnConfirm').click( function () { recDeleting(type, row.id) });
                $('#delModal').modal();
            } else {
                alert("No selected records!");
            }
        }

        function recDeleting(type, id) {
            if (id > 0) {
                fetch(type.toLowerCase() +"/delete?id=" + id)
                    .then(response => recSearch(type));
            }
        }
        
        function recConfirm(id) {
            var rows = $('#dgUsers').datagrid('getSelections');
            if (!rows) return;
            
            for (let row of rows) {
                if (row.id > 0) {
                    fetch("users/confirm?id=" + row.id)
                        .then(response => recSearch("Users"));
                }
            }
        }

        function recSearch(type) {
            var f = {};

            f.username = $('#username' + type).val();
            if (type === "Points") {
                f.type = $('#type').val();
                f.name = $('#name'+ type).val();
                f.address = $('#address').val();
            }
            $('#dg' + type).datagrid('load', f);
        }
        
        function showNew(){
            var f = { confirmed: false };
            $('#dgUsers').datagrid('load', f);
        }
        
        function formatType(val,row) {
            if (val === 1) val = "Waste recycling";
            if (val === 2) val = "Bicycle rental";
            if (val === 3) val = "Eco cafe";
            return val; 
        }
        
        function formatUsername(val,row) {
            return row.user.username;; 
        }
        
        function formatConfirmed(val,row) {
            return row.confirmed ? '<i class="fas fa-check"></i>' : '<i class="fas fa-times"></i>'; 
        }
    </script>
</html>
