export default function StatCard({
title,
value,
icon
}:any){

return (

<div className="stat-card">

<div className="stat-icon">
{icon}
</div>

<div>

<p>{title}</p>

<h1>{value}</h1>

</div>

</div>

)

}
