namespace SmartCharityAPI.DTOs
{
    public class HinhAnhSanPhamDTO
    {
        public int Id { get; set; }
        public string Url { get; set; } = "";

        public int SanPhamId { get; set; }
        public bool IsChinh { get; set; }
    }

}
