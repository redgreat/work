#入库
SELECT
	a.MaterialNO AS 编码,
	a.InOROustockNO AS 入库单号,
	ISNULL(CASE WHEN w.WareHouseLevel = 1 THEN a.CustStoreName ELSE ww.WareHouseName END,a.CustStoreName) AS 仓库,
	CASE WHEN w.WareHouseLevel = 2 THEN a.CustStoreName END AS 二级仓库,
	a.MaterialName AS 型号,
	d.Name AS 入库单类型,
	cc.Name AS 入库操作人,
	c.AuditTime AS 审核时间,
	aa.Name AS 审核人,
	c.DeliveryAddress AS 收货地址
	FROM [dbo].[WH_Material_State] a WITH(NOLOCK)
	LEFT JOIN dbo.WH_InstockInfo c WITH(NOLOCK) ON c.Id = a.InOROuStockID
	LEFT JOIN PublicCenterByHZ.[UserCenter-2015].dbo.Sys_User aa
	ON aa.Id=c.AuditPerson
	LEFT JOIN dbo.Basic_DataDictionary d WITH(NOLOCK) ON d.Id = c.InStockType
	LEFT JOIN PublicCenterByHZ.[UserCenter-2015].dbo.Sys_User cc
	ON cc.Id=c.InStockPerson
	LEFT JOIN dbo.Basic_Warehouse w ON w.Id = a.CustStoreID
	LEFT JOIN dbo.Basic_Warehouse ww ON ww.Id = w.ParentId
	WHERE a.Deleted=0
	AND c.Deleted = 0
	AND d.Name <> '采购入库'
	AND c.AuditState IN ('已审核','确认收货')
	AND a.IsInstall <> '已加装'
	AND c.AuditTime >= '2017-06-01'
    AND c.AuditTime < '2017-07-01';
#出库
SELECT
	a.MaterialNO AS 编码,
	a.InOROustockNO AS 出库单号,
	ISNULL(CASE WHEN w.WareHouseLevel = 1 THEN a.CustStoreName ELSE ww.WareHouseName END,a.CustStoreName) AS 仓库,
	CASE WHEN w.WareHouseLevel = 2 THEN a.CustStoreName END AS 二级仓库,
	a.MaterialName AS 型号,
	d.Name AS 入库单类型,
	cc.Name AS 入库操作人,
	c.AuditTime AS 审核时间,
	aa.Name AS 审核人,
	c.DeliveryAddress AS 收货地址
	FROM [dbo].[WH_Material_State] a WITH(NOLOCK)
	LEFT JOIN dbo.WH_OutstockInfo c WITH(NOLOCK) ON c.Id = a.InOROuStockID
	LEFT JOIN PublicCenterByHZ.[UserCenter-2015].dbo.Sys_User aa
	ON aa.Id=c.AuditPerson
	LEFT JOIN dbo.Basic_DataDictionary d WITH(NOLOCK) ON d.Id = c.OutStockType
	LEFT JOIN PublicCenterByHZ.[UserCenter-2015].dbo.Sys_User cc
	ON cc.Id=c.OutStockPerson
	LEFT JOIN dbo.Basic_Warehouse w ON w.Id = a.CustStoreID
	LEFT JOIN dbo.Basic_Warehouse ww ON ww.Id = w.ParentId
	WHERE a.Deleted=0
	AND c.Deleted = 0
	--AND d.Name <> '采购入库'
	AND a.IsInstall <> '已加装'
	AND c.AuditState IN ('已审核','已回执')
	AND c.AuditTime >= '2017-06-01'
    AND c.AuditTime < '2017-07-01';