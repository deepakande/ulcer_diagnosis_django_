from django.shortcuts import render
from django.core.files.storage import FileSystemStorage
from utils.predict import predict_image_class

def upload_image(request):
    context = {}
    if request.method == 'POST' and request.FILES['image']:
        image = request.FILES['image']
        fs = FileSystemStorage()
        filename = fs.save(image.name, image)
        file_path = fs.path(filename)
        try:
            prediction = predict_image_class(file_path)
            context['prediction'] = prediction
            context['filename'] = image.name
        except Exception as e:
            context['error'] = str(e)
    return render(request, 'upload.html', context)

