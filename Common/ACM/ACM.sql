SELECT * FROM CM.Sites
SELECT * FROM CM.PageTypes WHERE PageTypeURL LIKE '%Gift%'
SELECT * FROM CM.PageDefs WHERE SiteID = 4 AND PageTypeID = 53 ORDER BY PageDefID
SELECT * FROM CM.PageVersions WHERE PageDefID IN (45) ORDER BY VersionNumber DESC
SELECT * FROM CM.PageVersionLongStringProps where PageVersionID = 298

SELECT * FROM CM.SitePageTypes WHERE SiteID = 4 AND PageTypeID = 53 -- AND ConcurrencyID = XXX


SELECT PT.PageTypeName, PT.DefaultDescription, PT.PermissionGroupCodeName, PV.Title, PV.URLTitle, PD.*
FROM CM.PageDefs PD
	INNER JOIN CM.PageTypes PT ON PD.PageTypeID = PT.PageTypeID
	INNER JOIN (SELECT MAX(PageVersionID) AS PageVersionID, PageDefID FROM CM.PageVersions GROUP BY PageDefID) AS PVK ON PVK.PageDefID = PD.PageDefID
	INNER JOIN CM.PageVersions PV ON PV.PageVersionID = PVK.PageVersionID
WHERE PD.PageDefID = 16