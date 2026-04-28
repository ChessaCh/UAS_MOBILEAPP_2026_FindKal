from django.core.management.base import BaseCommand
from myapp.models import SurveyQuestion


QUESTIONS = [
    {
        "question_text": "Apa nama mall terbesar yang ada di kawasan BSD City?",
        "option_a": "Aeon Mall BSD",
        "option_b": "Living World",
        "option_c": "Grand Lucky",
        "option_d": "Mall@Alam Sutera",
        "correct_index": 0,
        "area_tag": "BSD",
        "is_demo": True,   # Q1
    },
    {
        "question_text": "Jalan utama yang menjadi pusat komersial BSD City disebut?",
        "option_a": "Jl. Pahlawan Seribu",
        "option_b": "Jl. BSD Grand Boulevard",
        "option_c": "Jl. Raya Serpong",
        "option_d": "Jl. Alam Sutera",
        "correct_index": 1,
        "area_tag": "BSD",
        "is_demo": False,  # Q2
    },
    {
        "question_text": "Universitas mana yang berlokasi di BSD City?",
        "option_a": "Universitas Pelita Harapan",
        "option_b": "Binus University",
        "option_c": "Universitas Multimedia Nusantara (UMN)",
        "option_d": "Universitas Prasetiya Mulya",
        "correct_index": 3,
        "area_tag": "BSD",
        "is_demo": True,   # Q3
    },
    {
        "question_text": "Kawasan perumahan premium di BSD yang dikenal dengan konsep 'green living'?",
        "option_a": "Kota Wisata",
        "option_b": "Summarecon Serpong",
        "option_c": "Green Cove BSD",
        "option_d": "The Icon BSD",
        "correct_index": 2,
        "area_tag": "BSD",
        "is_demo": False,  # Q4
    },
    {
        "question_text": "Apa nama taman kota yang populer di BSD City untuk jogging dan bersepeda?",
        "option_a": "Taman Kota 1 BSD",
        "option_b": "Bumi Serpong Damai Park",
        "option_c": "Taman Giri Loka",
        "option_d": "Alun-Alun Serpong",
        "correct_index": 0,
        "area_tag": "BSD",
        "is_demo": False,  # Q5
    },
    {
        "question_text": "Stasiun kereta terdekat dari pusat BSD City adalah?",
        "option_a": "Stasiun Cisauk",
        "option_b": "Stasiun Rawa Buntu",
        "option_c": "Stasiun Serpong",
        "option_d": "Stasiun Sudimara",
        "correct_index": 1,
        "area_tag": "Serpong",
        "is_demo": False,  # Q6
    },
    {
        "question_text": "Rumah sakit besar yang terletak di dalam kawasan BSD City?",
        "option_a": "RS Eka Hospital",
        "option_b": "RS Omni",
        "option_c": "RS Siloam",
        "option_d": "RS Mandaya",
        "correct_index": 0,
        "area_tag": "BSD",
        "is_demo": True,   # Q7
    },
    {
        "question_text": "Nama pengembang utama yang membangun BSD City adalah?",
        "option_a": "Sinar Mas Land",
        "option_b": "Ciputra Group",
        "option_c": "Lippo Group",
        "option_d": "Agung Podomoro",
        "correct_index": 0,
        "area_tag": "BSD",
        "is_demo": False,  # Q8
    },
    {
        "question_text": "Area kuliner/food market outdoor yang terkenal di BSD City yang biasa ramai di malam hari?",
        "option_a": "The Breeze BSD",
        "option_b": "Bintaro Xchange",
        "option_c": "Summarecon Mall",
        "option_d": "Alam Sutera Night Market",
        "correct_index": 0,
        "area_tag": "BSD",
        "is_demo": True,   # Q9
    },
    {
        "question_text": "Serpong secara administratif termasuk dalam wilayah mana?",
        "option_a": "Kota Tangerang",
        "option_b": "Kabupaten Tangerang",
        "option_c": "Kota Tangerang Selatan",
        "option_d": "Kota Serang",
        "correct_index": 2,
        "area_tag": "Serpong",
        "is_demo": False,  # Q10
    },
]


class Command(BaseCommand):
    help = "Seed SurveyQuestion table with BSD/Serpong local knowledge questions"

    def add_arguments(self, parser):
        parser.add_argument(
            "--clear",
            action="store_true",
            help="Delete all existing questions before seeding",
        )

    def handle(self, *args, **options):
        if options["clear"]:
            deleted, _ = SurveyQuestion.objects.all().delete()
            self.stdout.write(self.style.WARNING(f"Deleted {deleted} existing questions."))

        created = 0
        skipped = 0
        for q in QUESTIONS:
            obj, was_created = SurveyQuestion.objects.get_or_create(
                question_text=q["question_text"],
                defaults={k: v for k, v in q.items() if k != "question_text"},
            )
            if was_created:
                created += 1
            else:
                skipped += 1

        self.stdout.write(
            self.style.SUCCESS(
                f"Done. Created: {created}, Skipped (already exist): {skipped}"
            )
        )
